class Founder::InitialMetricsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_startup

  def new
    redirect_to founder_root_path if @startup.monthly_metrics.any?
    @months = [2.months.ago, 1.month.ago, 0.months.ago].map { |d| d.beginning_of_month.to_date }
    @monthly_metrics = @months.map { |m| @startup.monthly_metrics.new(period: m) }
  end

  def create
    @monthly_metrics = []
    success = true
    
    monthly_metrics_params.each do |p|
      metric = @startup.monthly_metrics.new(p)
      @monthly_metrics << metric
      success = false unless metric.save
    end

    if success
      redirect_to founder_root_path, notice: "Thank you for providing your initial metrics!"
    else
      @months = @monthly_metrics.map(&:period)
      # Re-render with the objects that may have errors
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_startup
    @startup = current_user.startup
    # authorize @startup, :update?
  end

  def monthly_metrics_params
    params.require(:monthly_metrics).map do |p|
      p.permit(
        :period,
        :mrr,
        :new_paying_customers,
        :churned_customers,
        :cash_at_hand,
        :burn_rate,
        :product_progress,
        :funding_stage,
        :funds_raised,
        :investors_engaged
      )
    end
  end
end
