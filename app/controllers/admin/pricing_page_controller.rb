module Admin
  class PricingPageController < RailsAdmin::MainController
    include PricingPageConcern

    # GET /admin/pricing_page/:id/edit
    def edit
      @pricing_page = if params[:id].present?
        ::PricingPage.find_by(id: params[:id])
      elsif params[:slug].present?
        begin
          if ActiveRecord::Base.connection.column_exists?(:pricing_pages, :slug)
            ::PricingPage.find_by(slug: params[:slug])
          else
            nil
          end
        rescue StandardError
          nil
        end
      end
      @pricing_page ||= ::PricingPage.first_or_create!(title: "Pricing")
      structured = parse_pricing_structured_content(@pricing_page.content)
      @pricing_tiers = ::PricingContent.tiers(structured)
      @pricing_hero = ::PricingContent.hero(structured)
    end

    # PATCH /admin/pricing_page/:id
    def update
      @pricing_page = if params[:id].present?
        ::PricingPage.find_by(id: params[:id])
      elsif params[:slug].present?
        begin
          if ActiveRecord::Base.connection.column_exists?(:pricing_pages, :slug)
            ::PricingPage.find_by(slug: params[:slug])
          else
            nil
          end
        rescue StandardError
          nil
        end
      end
      @pricing_page ||= ::PricingPage.first_or_create!(title: "Pricing")
      # Log incoming params keys for debugging
      Rails.logger.info("[Admin::PricingPage] update called params_keys=#{params.keys.inspect} has_pricing_content=#{params[:pricing_content].present?} has_pricing_page=#{params[:pricing_page].present?}")

      # Update title/content if present (standard form)
      if params[:pricing_page].present?
        begin
          @pricing_page.update!(pricing_page_params)
        rescue => e
          Rails.logger.error("[Admin::PricingPage] pricing_page update failed: #{e.message}")
        end
      end

      # Update structured pricing sections if submitted
      if params[:pricing_content].present?
        content = parse_pricing_structured_content(@pricing_page.content).with_indifferent_access
        pc = params.require(:pricing_content).permit!.to_h.with_indifferent_access

        # hero - merge with existing so blank fields don't wipe values
        if pc.key?(:hero) || pc.key?("hero")
          existing_hero = content[:hero] || {}
          new_title = pc.dig(:hero, :title).to_s.strip
          new_sub = pc.dig(:hero, :subtitle).to_s.strip
          content[:hero] = {
            title: new_title.empty? ? (existing_hero["title"] || existing_hero[:title] || "") : new_title,
            subtitle: new_sub.empty? ? (existing_hero["subtitle"] || existing_hero[:subtitle] || "") : new_sub
          }
        end

        # tiers - only update tiers when the form submitted any tiers keys
        if pc.key?(:tiers) || pc.key?("tiers")
          tiers_param = pc[:tiers] || []
          existing_tiers = content[:pricing_tiers] || []
          tiers = []
          if tiers_param.is_a?(Hash)
            tiers_param.to_a.sort_by { |k, _| k.to_i }.each_with_index do |(_, t), i|
              merged = merge_tier_with_existing(t, existing_tiers[i] || {})
              tiers << normalize_tier_params(merged)
            end
          elsif tiers_param.is_a?(Array)
            tiers_param.each_with_index do |t, i|
              merged = merge_tier_with_existing(t, existing_tiers[i] || {})
              tiers << normalize_tier_params(merged)
            end
          end

          # enforce single highlight: if multiple tiers marked highlight, keep only the last one
          if tiers.any?
            highlight_indexes = tiers.each_index.select { |i| tiers[i][:highlight] }
            if highlight_indexes.size > 1
              last = highlight_indexes.last
              tiers.each_with_index { |t, i| t[:highlight] = (i == last) }
            end
          end

          # save tiers under `pricing_tiers` to match PricingContent.tiers
          content[:pricing_tiers] = tiers
        end

        # persist when the pricing_content form was submitted
        safe_slug = (@pricing_page.respond_to?(:slug) ? @pricing_page.slug : nil) rescue nil
        Rails.logger.info("[Admin::PricingPage] Saving pricing content for page_id=#{@pricing_page.id} slug=#{safe_slug.inspect}")
        @pricing_page.update!(content: content.to_json)
        Rails.logger.info("[Admin::PricingPage] Saved content (#{@pricing_page.content.to_s[0..200]}...)")
      end
      redirect_to admin_edit_admin_pricing_page_simple_path, notice: "Pricing page saved"
    end

    private

    def pricing_page_params
      params.require(:pricing_page).permit(:title, :content)
    end

    def normalize_tier_params(t)
      t = t.to_unsafe_h if t.respond_to?(:to_unsafe_h)
      features = t.fetch("features", t.fetch(:features, [])) || []
      features = features.values if features.is_a?(Hash)
      features = Array(features).map(&:to_s).map(&:strip).reject(&:blank?)

      {
        name: (t["name"] || t[:name] || "").to_s,
        price: (t["price"] || t[:price] || "").to_s,
        description: (t["description"] || t[:description] || "").to_s,
        features: features,
        cta: (t["cta"] || t[:cta] || "").to_s,
        cta_link: (t["cta_link"] || t[:cta_link] || "").to_s,
        highlight: %w[1 true t yes].include?((t["highlight"] || t[:highlight]).to_s.strip.downcase)
      }
    end

    def merge_tier_with_existing(params_tier, existing)
      p = params_tier.respond_to?(:to_unsafe_h) ? params_tier.to_unsafe_h : (params_tier || {})
      e = existing || {}

      pick = lambda do |key|
        v = p[key.to_s] || p[key.to_sym]
        if key == :highlight
          # For checkboxes, missing param means false; only preserve when explicit
          if v.nil?
            false
          else
            v.to_s == "1"
          end
        else
          if v.nil?
            e[key.to_s] || e[key.to_sym]
          else
            sv = v.respond_to?(:strip) ? v.to_s.strip : v
            sv == "" ? (e[key.to_s] || e[key.to_sym]) : v
          end
        end
      end

      features_param = p["features"] || p[:features]
      features = if features_param.nil? || (features_param.respond_to?(:empty?) && features_param.empty?)
                   e["features"] || e[:features] || []
      else
                   features_param
      end

      {
        "name" => pick.call(:name),
        "price" => pick.call(:price),
        "description" => pick.call(:description),
        "features" => features,
        "cta" => pick.call(:cta),
        "cta_link" => pick.call(:cta_link),
        "highlight" => pick.call(:highlight)
      }
    end
  end
end
