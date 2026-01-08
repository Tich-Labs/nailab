module Admin
  class PricingPageController < RailsAdmin::MainController
    include PricingPageConcern

    # GET /admin/pricing_page/:id/edit
    def edit
      @pricing_page = PricingPage.find_by(id: params[:id]) || PricingPage.first_or_create!(title: "Pricing")
      structured = parse_pricing_structured_content(@pricing_page.content)
      @pricing_tiers = PricingContent.tiers(structured)
      @pricing_hero = PricingContent.hero(structured)
    end

    # PATCH /admin/pricing_page/:id
    def update
      @pricing_page = PricingPage.find_by(id: params[:id]) || PricingPage.first_or_create!(title: "Pricing")
      if params[:pricing_page].present?
        @pricing_page.update!(pricing_page_params)
      end
      redirect_to edit_admin_pricing_page_path(@pricing_page), notice: "Pricing page saved"
    end

    private

    def pricing_page_params
      params.require(:pricing_page).permit(:title, :content)
    end
  end
end
