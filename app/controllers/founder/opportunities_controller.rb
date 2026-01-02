class Founder::OpportunitiesController < Founder::BaseController
  before_action :set_opportunity, only: %i[show apply]

  def index
    @opportunities = Opportunity.all
  end

  def show
  end

  def apply
    # redirect to external or show form
    redirect_to @opportunity.application_url
  end

  private

  def set_opportunity
    @opportunity = Opportunity.find(params[:id])
  end
end
