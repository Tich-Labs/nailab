class Founder::ProgressesController < Founder::BaseController
  def show
    @milestones = current_user.milestones
    @monthly_metrics = current_user.monthly_metrics
    @baseline_plans = current_user.baseline_plans
  end
end
