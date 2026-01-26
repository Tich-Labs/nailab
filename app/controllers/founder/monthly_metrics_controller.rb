class Founder::MonthlyMetricsController < Founder::BaseController
  before_action :set_monthly_metric, only: %i[show edit update destroy]

  def index
    @monthly_metrics = current_user.startup.monthly_metrics
  end

  def show
  end

  def new
    @monthly_metric = current_user.startup.monthly_metrics.build
  end

  def create
    @monthly_metric = current_user.startup.monthly_metrics.build(monthly_metric_params)
    @monthly_metric.user = current_user
    # Ensure runway is always derived (not mass-assignable)
    if @monthly_metric.save
      redirect_to founder_monthly_metrics_path, notice: "Metric created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    # Prevent manual editing of derived fields
    if @monthly_metric.update(monthly_metric_params)
      redirect_to founder_monthly_metrics_path, notice: "Metric updated."
    else
      render :edit
    end
  end

  private

  def set_monthly_metric
    @monthly_metric = current_user.startup.monthly_metrics.find(params[:id])
  end

  def monthly_metric_params
    params.require(:monthly_metric).permit(
      :period, :month, :mrr, :revenue, :new_paying_customers, :customers,
      :churned_customers, :churn_rate, :cash_at_hand, :burn_rate,
      :product_progress, :funding_stage, :funds_raised, :investors_engaged, :notes
    )
  end
end
