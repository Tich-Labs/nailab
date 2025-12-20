class Founder::StartupProfilesController < Founder::BaseController
  before_action :set_startup_profile

  def show
  end

  def edit
  end

  def update
    if @startup_profile.update(startup_profile_params)
      redirect_to founder_startup_profile_path, notice: 'Profile updated successfully.'
    else
      render :edit
    end
  end

  private

  def set_startup_profile
    @startup_profile = current_user.startup_profile
  end

  def startup_profile_params
    cast_boolean_param(
      params.require(:startup_profile).permit(
        :startup_name,
        :logo_url,
        :description,
        :stage,
        :target_market,
        :value_proposition,
        :sector,
        :funding_stage,
        :funding_raised,
        :website_url,
        :profile_visibility,
        team_members: [:id, :name, :role]
      ),
      :profile_visibility
    )
  end

  def cast_boolean_param(attributes, key)
    return attributes unless attributes.key?(key)
    attributes[key] = ActiveModel::Type::Boolean.new.cast(attributes[key])
    attributes
  end
end