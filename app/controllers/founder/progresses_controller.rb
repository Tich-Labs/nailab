class Founder::ProgressesController < Founder::BaseController
  def show
    @milestones = current_user.milestones
    @monthly_metrics = current_user.monthly_metrics
    @startup = current_user.startup
    @startup_updates = @startup&.startup_updates&.order(report_year: :desc, report_month: :desc) || []
  end

  def onboarding
    if request.get?
      # Set up 3 months, pre-fill where possible
      @periods = 3.downto(1).map { |i| (Date.today - i.months).beginning_of_month }
      @monthly_metrics = @periods.map { |period| MonthlyMetric.new(period: period) }
    else
      # Handle submission of 3 months
      # params[:monthly_metrics] is an array of hashes
      # Validate and save each
      # (Implementation to be filled in next step)
    end
  end
end
