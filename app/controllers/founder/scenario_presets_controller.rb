class Founder::ScenarioPresetsController < Founder::BaseController
  before_action :set_preset, only: %i[edit update destroy]

  def index
    @presets = ScenarioPreset.where(user: nil).or(ScenarioPreset.where(user: current_user))
  end

  def new
    @preset = ScenarioPreset.new
  end

  def create
    @preset = ScenarioPreset.new(preset_params)
    @preset.user = current_user
    if @preset.save
      redirect_to founder_scenario_presets_path, notice: "Preset saved."
    else
      render :new
    end
  end

  def edit; end

  def update
    if @preset.update(preset_params)
      redirect_to founder_scenario_presets_path, notice: "Preset updated."
    else
      render :edit
    end
  end

  def destroy
    @preset.destroy
    redirect_to founder_scenario_presets_path, notice: "Preset deleted."
  end

  private

  def set_preset
    @preset = ScenarioPreset.find(params[:id])
  end

  def preset_params
    params.require(:scenario_preset).permit(:name, :growth_pct, :churn_pct, :burn_change_pct)
  end
end
