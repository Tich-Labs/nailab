module Admin
  module PricingPage
    # Legacy controller removed — any requests to this controller should return 404.
    class SectionsController < RailsAdmin::MainController
      before_action :not_found

      private

      def not_found
        raise ActionController::RoutingError.new("Not Found")
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
