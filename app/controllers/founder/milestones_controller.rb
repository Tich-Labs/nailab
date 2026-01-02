class Founder::MilestonesController < Founder::BaseController
  before_action :set_milestone, only: %i[show edit update destroy]

  def index
    @milestones = current_user.startup.milestones
  end

  def show
  end

  def new
    @milestone = current_user.startup.milestones.build
  end

  def create
    @milestone = current_user.startup.milestones.build(milestone_params)
    if @milestone.save
      redirect_to founder_milestones_path, notice: "Milestone created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @milestone.update(milestone_params)
      redirect_to founder_milestones_path, notice: "Milestone updated."
    else
      render :edit
    end
  end

  def destroy
    @milestone.destroy
    redirect_to founder_milestones_path, notice: "Milestone deleted."
  end

  private

  def set_milestone
    @milestone = current_user.startup.milestones.find(params[:id])
  end

  def milestone_params
    params.require(:milestone).permit(:title, :description, :due_date, :completed)
  end
end
