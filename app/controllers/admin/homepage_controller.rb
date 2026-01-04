require "ostruct"

module Admin
  # Controller: Admin::HomepageController
  # Purpose: Per-homepage section editors (hero, impact_network, focus_areas).
  # Renders the per-section admin pages located in `app/views/admin/homepage/`.
  # Use `Admin::HomepagesController` for the central homepage sections dashboard.
  class HomepageController < RailsAdmin::MainController
    include AdminLayoutData
      before_action :set_logos, only: %i[impact_network reorder toggle]
      before_action :prepare_home_content, only: %i[hero update_hero how_we_support update_how_we_support cta update_cta who_we_are update_who_we_are connect_grow_impact update_connect_grow_impact our_impact update_our_impact]
      HERO_DEFAULT = {
        title: "Grow your startup with people who’ve done it before.",
        subtitle: "Book weekly 1-on-1 mentorship sessions with seasoned business leaders and build your startup alongside a supportive community of founders actively building high-growth, tech-enabled startups across Africa.",
        image_url: "images-events/Funding_Access.original.jpg",
        cta_text: "Request Mentorship",
        cta_link: "/founder_onboarding",
        secondary_cta: {
          label: "Become a Mentor",
          link: "/mentor_onboarding"
        }
      }.freeze

    def impact_network
      # @logos available for management; preview will use active logos
      @preview_logos = Logo.where(active: true).order(:display_order)
    end

    def hero
        hero_json = @home_content_json[:hero]
        @hero_content = if hero_json.is_a?(Hash)
          hero_json.with_indifferent_access
        else
          HERO_DEFAULT.deep_dup.with_indifferent_access
        end
        @hero_slides = hero_slides_from_json(@hero_content)
        @hero_secondary_cta = (@hero_content[:secondary_cta].is_a?(Hash) ? @hero_content[:secondary_cta] : {}).with_indifferent_access
        @preview_hero = @hero_slides.first
        connect_json = @home_content_json[:connect_grow_impact].is_a?(Hash) ? @home_content_json[:connect_grow_impact] : {}
        @connect_stats = connect_json[:stats].presence || PagesController::DEFAULT_CONNECT_STATS
    end

      def update_hero
        @hero_content = hero_params_with_defaults
        @home_content_json[:hero] = @hero_content.except(:slides)
          # Persist connect stats if provided from the editor
          if params[:connect_stats].present?
            stats = Array.wrap(params[:connect_stats]).map do |s|
              {
                value: s.is_a?(Hash) ? s["value"] : s[:value],
                label: s.is_a?(Hash) ? s["label"] : s[:label]
              }
            end
            @home_content_json[:connect_grow_impact] ||= {}
            @home_content_json[:connect_grow_impact][:stats] = stats
          end
          if @home_page.update(structured_content: @home_content_json.to_json)
            redirect_to admin_homepage_hero_path, notice: "Hero updated", status: :see_other
          else
          flash.now[:alert] = "Unable to save hero"
          @hero_slides = hero_slides_from_json(@hero_content)
          @hero_secondary_cta = (@hero_content[:secondary_cta].is_a?(Hash) ? @hero_content[:secondary_cta] : {}).with_indifferent_access
          render :hero, status: :unprocessable_entity
          end
      end

    def focus_areas
      @focus_areas = FocusArea.order(:display_order)
      @preview_focus_areas = @focus_areas.where(active: true)
      respond_to do |format|
        format.html { render template: "admin/homepage/focus_areas/index" }
        format.json { render json: { focus_areas: @focus_areas } }
      end
    end

    def cta
        @home_content_json ||= {}.with_indifferent_access
      @bottom_cta = bottom_cta_content
    end

    def how_we_support
      @how_we_support_items = if @home_content_json[:how_we_support].is_a?(Array)
        @home_content_json[:how_we_support].map { |i| i.is_a?(Hash) ? i.with_indifferent_access : i }
      else
        PagesController::DEFAULT_SUPPORT_ITEMS
      end
    end

    def who_we_are
      content = @home_content_json[:who_we_are]
      @who_we_are_content = if content.is_a?(Hash)
        content.with_indifferent_access
      else
        {}.with_indifferent_access
      end
      # Prefer an attached image if present; fallback to stored image_url
      if @home_page.respond_to?(:who_we_are_image) && @home_page.who_we_are_image.attached?
        begin
          @who_we_are_image_url = url_for(@home_page.who_we_are_image)
        rescue => e
          Rails.logger.debug("Unable to generate who_we_are image url: #{e.message}")
          @who_we_are_image_url = @who_we_are_content["image_url"] || @who_we_are_content[:image_url]
        end
      else
        @who_we_are_image_url = @who_we_are_content["image_url"] || @who_we_are_content[:image_url]
      end
    end

    def connect_grow_impact
      connect_json = @home_content_json[:connect_grow_impact].is_a?(Hash) ? @home_content_json[:connect_grow_impact] : {}
      @connect_title = connect_json[:title].presence || "Connect. Grow. Impact."
      @connect_intro = connect_json[:intro].presence || PagesController::DEFAULT_CONNECT_INTRO
      @connect_stats = connect_json[:stats].presence || PagesController::DEFAULT_CONNECT_STATS
      @connect_cards = if connect_json[:cards].is_a?(Array)
        connect_json[:cards].map { |c| c.is_a?(Hash) ? c.with_indifferent_access : {} }
      else
        PagesController::DEFAULT_CONNECT_CARDS
      end
    end

    def update_connect_grow_impact
      incoming = params[:connect] || {}
      incoming = incoming.to_unsafe_h if incoming.is_a?(ActionController::Parameters)
      title = incoming["title"].to_s.strip
      intro = incoming["intro"].to_s.strip

      cards_in = incoming["cards"] || {}
      cards = []
      if cards_in.is_a?(Array)
        cards_in.each do |c|
          c = c.is_a?(ActionController::Parameters) ? c.to_unsafe_h : c
          cards << {
            title: c["title"].to_s.strip,
            description: c["description"].to_s.strip,
            cta_label: c["cta_label"].to_s.strip,
            cta_link: c["cta_link"].to_s.strip
          }
        end
      elsif cards_in.is_a?(Hash)
        cards_in.to_h.each do |_idx, vals|
          vals = vals.is_a?(ActionController::Parameters) ? vals.to_unsafe_h : vals
          cards << {
            title: vals["title"].to_s.strip,
            description: vals["description"].to_s.strip,
            cta_label: vals["cta_label"].to_s.strip,
            cta_link: vals["cta_link"].to_s.strip
          }
        end
      end

      @home_content_json[:connect_grow_impact] ||= {}
      @home_content_json[:connect_grow_impact][:title] = title
      @home_content_json[:connect_grow_impact][:intro] = intro
      @home_content_json[:connect_grow_impact][:cards] = cards

      if params[:connect_stats].present?
        stats = Array.wrap(params[:connect_stats]).map do |s|
          s = s.is_a?(ActionController::Parameters) ? s.to_unsafe_h : s
          { value: s["value"].to_s, label: s["label"].to_s }
        end
        @home_content_json[:connect_grow_impact][:stats] = stats
      end

      if @home_page.update(structured_content: @home_content_json.to_json)
        redirect_to admin_homepage_connect_grow_impact_path, notice: "Connect. Grow. Impact. updated", status: :see_other
      else
        flash.now[:alert] = "Unable to save Connect. Grow. Impact."
        @connect_intro = intro
        @connect_cards = cards
        render :connect_grow_impact, status: :unprocessable_entity
      end
    end

    def update_who_we_are
      payload = who_we_are_params
      # Handle optional uploaded image file `who_we_are[image_file]`. If provided, attach to HomePage
      if params[:who_we_are].present? && params[:who_we_are][:image_file].present?
        begin
          uploaded = params[:who_we_are][:image_file]
          # attach the uploaded file to the homepage
          @home_page.who_we_are_image.attach(uploaded)
          # generate a URL for the attached blob and prefer it
          payload[:image_url] = url_for(@home_page.who_we_are_image) if @home_page.who_we_are_image.attached?
        rescue => e
          Rails.logger.warn("WhoWeAre image attach failed: #{e.message}")
        end
      end

      @home_content_json[:who_we_are] = payload
      if @home_page.update(structured_content: @home_content_json.to_json)
        redirect_to admin_homepage_who_we_are_path, notice: "Who we are updated", status: :see_other
      else
        flash.now[:alert] = "Unable to save Who We Are"
        @who_we_are_content = payload
        render :who_we_are, status: :unprocessable_entity
      end
    end

    def update_how_we_support
      incoming = params[:support_items] || {}
      # `incoming` may be an ActionController::Parameters (unpermitted). Convert safely to a Hash.
      if incoming.is_a?(ActionController::Parameters)
        incoming = incoming.to_unsafe_h
      end
      items = []
      # incoming expected as hash of indexed entries (0 => {title=>.., description=>..})
      if incoming.is_a?(ActionController::Parameters) || incoming.is_a?(Hash)
        incoming.to_h.each do |_idx, vals|
          vals = vals.is_a?(ActionController::Parameters) ? vals.to_unsafe_h : vals.to_h
          items << {
            title: vals["title"].to_s.strip,
            description: vals["description"].to_s.strip,
            cta_label: vals["cta_label"].to_s.strip,
            cta_link: vals["cta_link"].to_s.strip
          }
        end
      elsif incoming.is_a?(Array)
        incoming.each do |vals|
          vals = vals.to_h
          items << {
            title: vals["title"].to_s.strip,
            description: vals["description"].to_s.strip,
            cta_label: vals["cta_label"].to_s.strip,
            cta_link: vals["cta_link"].to_s.strip
          }
        end
      end

      @home_content_json[:how_we_support] = items
      if @home_page.update(structured_content: @home_content_json.to_json)
        redirect_to admin_homepage_how_we_support_path, notice: "How we support updated", status: :see_other
      else
        flash.now[:alert] = "Unable to save support items"
        @how_we_support_items = items
        render :how_we_support, status: :unprocessable_entity
      end
    end

    def update_cta
        @home_content_json ||= {}.with_indifferent_access
      @home_content_json[:bottom_cta] = bottom_cta_params
      if @home_page.update(structured_content: @home_content_json.to_json)
        redirect_to admin_homepage_cta_path, notice: "CTA updated", status: :see_other
      else
        @bottom_cta = bottom_cta_content
        flash.now[:alert] = "Unable to save CTA"
        render :cta
      end
    end

    def our_impact
      impact_json = @home_content_json[:our_impact].is_a?(Hash) ? @home_content_json[:our_impact] : {}
      @impact_title = impact_json[:title].presence || "Our Impact"
      @impact_intro = impact_json[:intro].presence || "We partner with founders, mentors and partners to support startups across Africa."
      @impact_stats = impact_json[:stats].presence || [
        { value: "10+", label: "Years of Impact" },
        { value: "54", label: "African Countries" },
        { value: "30+", label: "Innovation Programs" },
        { value: "$100M", label: "Funding Facilitated" },
        { value: "1000", label: "Startups Supported" },
        { value: "50+", label: "Partners" }
      ]
    end

    def update_our_impact
      incoming = params[:impact] || {}
      incoming = incoming.to_unsafe_h if incoming.is_a?(ActionController::Parameters)
      title = incoming["title"].to_s.strip
      intro = incoming["intro"].to_s.strip

      if params[:impact_stats].present?
        stats = Array.wrap(params[:impact_stats]).map do |s|
          s = s.is_a?(ActionController::Parameters) ? s.to_unsafe_h : s
          { value: s["value"].to_s, label: s["label"].to_s }
        end
        @home_content_json[:our_impact] ||= {}
        @home_content_json[:our_impact][:stats] = stats
      end

      @home_content_json[:our_impact] ||= {}
      @home_content_json[:our_impact][:title] = title
      @home_content_json[:our_impact][:intro] = intro

      if @home_page.update(structured_content: @home_content_json.to_json)
        redirect_to admin_homepage_our_impact_path, notice: "Our Impact updated", status: :see_other
      else
        flash.now[:alert] = "Unable to save Our Impact."
        @impact_intro = intro
        render :our_impact, status: :unprocessable_entity
      end
    end

    def reorder
      id = params[:id]
      direction = params[:direction]
      logo = Logo.find_by(id: id)
      return redirect_to admin_homepage_impact_network_path, alert: "Logo not found" if logo.nil?

      if direction == "up"
        swap_with = Logo.where("display_order < ?", logo.display_order).order(display_order: :desc).first
      else
        swap_with = Logo.where("display_order > ?", logo.display_order).order(display_order: :asc).first
      end

      if swap_with
        logo.display_order, swap_with.display_order = swap_with.display_order, logo.display_order
        logo.save
        swap_with.save
      end

      redirect_to admin_homepage_impact_network_path, notice: "Order updated"
    end

    def toggle
      logo = Logo.find_by(id: params[:id])
      return redirect_to admin_homepage_impact_network_path, alert: "Logo not found" if logo.nil?

      logo.update(active: !logo.active)
      redirect_to admin_homepage_impact_network_path, notice: "Logo status updated"
    end

    private

    def prepare_home_content
      set_homepage
      @home_page.reload if @home_page&.persisted?
      raw_content = @home_page.structured_content
      @home_content_json = case raw_content
      when Hash then raw_content.with_indifferent_access
      when String
        begin
          JSON.parse(raw_content).with_indifferent_access
        rescue JSON::ParserError
          {}
        end
      else
        {}
      end.with_indifferent_access
      if Rails.env.development?
        Rails.logger.debug("HomePage parsed structured_content: ")
        Rails.logger.debug(@home_content_json.inspect)
      end
    end

    def hero_content_hash
      hero_json = @home_content_json[:hero]
      hero_attrs = hero_json.is_a?(Hash) ? hero_json.with_indifferent_access : {}.with_indifferent_access
      HERO_DEFAULT.deep_merge(hero_attrs)
    end

    def hero_params_with_defaults
      payload = hero_params.to_h.with_indifferent_access
      if payload[:secondary_cta].is_a?(Hash)
        payload[:secondary_cta] = payload[:secondary_cta].with_indifferent_access
      end
      HERO_DEFAULT.deep_merge(payload)
    end

    def hero_slides_from_json(hero_json)
      slides = hero_json[:slides].presence || hero_json[:slide].presence
      slides = Array.wrap(slides) if slides.present?
      if slides.blank? && hero_json[:title].present?
        slides = [ hero_json.slice(:title, :subtitle, :image_url, :cta_text, :cta_link) ]
      end
      return [] unless slides.present?
      slides.map do |attrs|
        OpenStruct.new(attrs.with_indifferent_access)
      end
    end

    def hero_params
      params.require(:hero).permit(:title, :subtitle, :image_url, :cta_text, :cta_link, secondary_cta: %i[label link])
    end

    def who_we_are_params
      params.require(:who_we_are).permit(:title, :paragraph_one, :paragraph_two, :subheading, :cta_label, :cta_link, :image_url).to_h.with_indifferent_access
    end

    def bottom_cta_content
      default = PagesController::DEFAULT_BOTTOM_CTA.deep_dup.with_indifferent_access
      existing = @home_content_json[:bottom_cta].presence || {}
      default.deep_merge(existing).with_indifferent_access
    end

    def bottom_cta_params
      params.require(:bottom_cta).permit(
        :heading,
        :body,
        primary_cta: %i[label link],
        secondary_cta: %i[label link]
      ).to_h.with_indifferent_access
    end

    def set_logos
      @logos = Logo.order(:display_order)
    end

    def set_homepage
      @home_page = HomePage.first_or_initialize
    end
  end
end
