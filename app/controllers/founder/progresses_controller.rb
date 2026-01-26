class Founder::ProgressesController < Founder::BaseController
  def show
    @milestones = current_user.milestones
    @monthly_metrics = current_user.monthly_metrics
    @startup = current_user.startup
    @startup_updates = @startup&.startup_updates&.order(report_year: :desc, report_month: :desc) || []
  end
end
