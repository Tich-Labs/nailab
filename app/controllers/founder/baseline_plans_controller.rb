class Founder::BaselinePlansController < Founder::BaseController
  before_action :set_baseline_plan, only: [:show, :edit, :update, :destroy]

  def index
    @baseline_plans = current_user.baseline_plans
  end

  def show
  end

  def new
    @baseline_plan = current_user.baseline_plans.new
  end

  def create
    @baseline_plan = current_user.baseline_plans.new(baseline_plan_params)
    if @baseline_plan.save
      redirect_to founder_baseline_plans_path, notice: 'Baseline plan was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @baseline_plan.update(baseline_plan_params)
      redirect_to founder_baseline_plans_path, notice: 'Baseline plan was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @baseline_plan.destroy
    redirect_to founder_baseline_plans_path, notice: 'Baseline plan was successfully destroyed.'
  end

  private

  def set_baseline_plan
    @baseline_plan = current_user.baseline_plans.find(params[:id])
  end

  def baseline_plan_params
    params.require(:baseline_plan).permit(:title, :description, :baseline_revenue, :baseline_customers, :baseline_burn_rate, :target_milestones)
  end
end
