module PricingPageConcern
  extend ActiveSupport::Concern

  private

  def load_pricing_content
    @pricing_page = PricingPage.first || PricingPage.new(title: "Pricing")
    structured_content = parse_pricing_structured_content(@pricing_page.content)
    @pricing_tiers = PricingContent.tiers(structured_content)
    @pricing_hero = PricingContent.hero(structured_content)
  end

  def parse_pricing_structured_content(content)
    return {} unless content.present?

    parsed = JSON.parse(content) rescue {}
    parsed.is_a?(Hash) ? parsed : {}
  end
end
