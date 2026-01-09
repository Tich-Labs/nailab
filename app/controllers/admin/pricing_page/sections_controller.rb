module Admin
  module PricingPage
    class SectionsController < RailsAdmin::MainController
      include ::PricingPageConcern

      # GET /admin/pricing_page/sections/edit
      def edit
        @pricing_page = ::PricingPage.find_by(id: 1) || ::PricingPage.first_or_create!(title: "Pricing")
        structured = parse_pricing_structured_content(@pricing_page.content)
        @pricing_tiers = ::PricingContent.tiers(structured)
        @pricing_hero = ::PricingContent.hero(structured)
      end

      # PATCH /admin/pricing_page/sections/edit
      def update
        @pricing_page = ::PricingPage.find_by(id: 1) || ::PricingPage.first_or_create!(title: "Pricing")

        content = parse_pricing_structured_content(@pricing_page.content)

        if params[:pricing_content].present?
          pc = params.require(:pricing_content).permit!

          # Hero
          if pc[:hero].present?
            content[:hero] = {
              title: pc[:hero][:title].to_s,
              subtitle: pc[:hero][:subtitle].to_s
            }
          end

          # Tiers - accept array or hash with numeric keys
          tiers_param = pc[:tiers] || []
          tiers = []
          if tiers_param.is_a?(Hash)
            tiers_param.to_a.sort_by { |k, _| k.to_i }.each do |_, t|
              tiers << normalize_tier_params(t)
            end
          elsif tiers_param.is_a?(Array)
            tiers_param.each do |t|
              tiers << normalize_tier_params(t)
            end
          end

          content[:pricing_tiers] = tiers
        end

        @pricing_page.update!(content: content.to_json)

        redirect_to "/admin/pricing_page/sections/edit", notice: "Pricing sections saved"
      end

      private

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
          highlight: (t["highlight"].to_s == "1")
        }
      end
    end
  end
end
# module Admin
#   module PricingPage
#     class SectionsController < ApplicationController
#       before_action :load_pricing_content

#       def edit
#         render template: "admin/pricing_page/sections/edit"
#       end

#       def update
#         @pricing_page = PricingPage.first_or_create!(title: "Pricing")
#         current_content = parse_pricing_structured_content(@pricing_page.content)

#         # Save hero section
#         hero_params = params.dig(:pricing_content, :hero)&.permit(:title, :subtitle) || {}
#         if hero_params.present?
#           current_content[:hero] = hero_params.to_h
#         end

#         # Save pricing tiers
#         tiers_params = params.dig(:pricing_content, :tiers) || {}
#         if tiers_params.present?
#           tiers = []
#           tiers_params.each do |index, tier_params|
#             if tier_params.is_a?(Hash)
#               features = tier_params[:features]&.values || []
#               tiers << {
#                 name: tier_params[:name]&.to_s&.strip,
#                 price: tier_params[:price]&.to_s&.strip,
#                 description: tier_params[:description]&.to_s&.strip,
#                 features: features.map { |f| f.to_s&.strip }.compact,
#                 cta: tier_params[:cta]&.to_s&.strip,
#                 cta_link: tier_params[:cta_link]&.to_s&.strip,
#                 highlight: tier_params[:highlight].present?
#               }
#             end
#           end
#           current_content[:pricing_tiers] = tiers
#         end

#         @pricing_page.update!(content: current_content.to_json)
#         redirect_to admin_pricing_page_sections_edit_path, notice: "Pricing page updated successfully"
#       end

#       private

#       def load_pricing_content
#         @pricing_page = PricingPage.first || PricingPage.new(title: "Pricing")
#         @structured_content = parse_pricing_structured_content(@pricing_page.content)
#         @pricing_tiers = PricingContent.tiers(@structured_content)
#         @pricing_hero = PricingContent.hero(@structured_content)
#       end

#       def parse_pricing_structured_content(content)
#         return {} unless content.present?
#         parsed = JSON.parse(content) rescue {}
#         parsed.is_a?(Hash) ? parsed.with_indifferent_access : {}
#       end
#     end
#   end
# end
