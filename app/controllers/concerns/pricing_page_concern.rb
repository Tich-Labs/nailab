module PricingPageConcern
  extend ActiveSupport::Concern

  private

  def load_pricing_content
    @pricing_page = StaticPage.find_by(slug: 'pricing') || StaticPage.new(slug: 'pricing', title: 'Pricing')
    structured_content = @pricing_page.structured_content.presence || {}
    @pricing_tiers = PricingContent.tiers(structured_content)
    @pricing_hero = PricingContent.hero(structured_content)
  end
end
