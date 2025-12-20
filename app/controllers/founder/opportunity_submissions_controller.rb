class Founder::OpportunitySubmissionsController < Founder::BaseController
  before_action :set_opportunity

  def create
    @submission = @opportunity.submissions.build(submission_params.merge(user: current_user))
    if @submission.save
      redirect_to founder_opportunity_path(@opportunity), notice: 'Submitted.'
    else
      redirect_back fallback_location: founder_opportunity_path(@opportunity), alert: 'Error.'
    end
  end

  private

  def set_opportunity
    @opportunity = Opportunity.find(params[:opportunity_id])
  end

  def submission_params
    params.require(:opportunity_submission).permit(:details)
  end
end