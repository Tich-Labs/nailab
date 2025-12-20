class Founder::MonthlyMetricsController < Founder::BaseController
  before_action :set_monthly_metric, only: %i[show edit update]

  def index
    @monthly_metrics = current_user.monthly_metrics
  end

  def show
  end

  def new
    @monthly_metric = current_user.monthly_metrics.build
  end

  def create
    @monthly_metric = current_user.monthly_metrics.build(monthly_metric_params)
    if @monthly_metric.save
      redirect_to founder_monthly_metrics_path, notice: "Metric created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @monthly_metric.update(monthly_metric_params)
      redirect_to founder_monthly_metrics_path, notice: "Metric updated."
    else
      render :edit
    end
  end

  private

  def set_monthly_metric
    @monthly_metric = current_user.monthly_metrics.find(params[:id])
  end

  def monthly_metric_params
    params.require(:monthly_metric).permit(:month, :revenue, :customers, :runway, :burn_rate, :growth_rate, :churn_rate, :notes)
  end
end
