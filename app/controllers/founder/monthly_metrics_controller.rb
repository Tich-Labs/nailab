class Founder::MonthlyMetricsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_startup
  before_action :set_monthly_metric, only: [:edit, :update]

  def index
    @monthly_metrics = @startup.monthly_metrics.order(period: :desc)
  end

  def new
    @monthly_metric = @startup.monthly_metrics.new
  end

  def create
    @monthly_metric = @startup.monthly_metrics.new(monthly_metric_params)
    if @monthly_metric.save
      redirect_to founder_monthly_metrics_path, notice: 'Monthly metric was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @monthly_metric.update(monthly_metric_params)
      redirect_to founder_monthly_metrics_path, notice: 'Monthly metric was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_startup
    @startup = current_user.startup
    # Pundit is used, but I'll assume a generic authorization for now
    # authorize @startup, :show?
  end

  def set_monthly_metric
    @monthly_metric = @startup.monthly_metrics.find(params[:id])
  end

  def monthly_metric_params
    params.require(:monthly_metric).permit(
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