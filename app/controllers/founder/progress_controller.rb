class Founder::ProgressController < Founder::BaseController
  def show
    @milestones = current_user.milestones
    @monthly_metrics = current_user.monthly_metrics
  end
end
