module MentorPortal
  class ProfilesController < MentorPortal::BaseController
    def show
      @profile = current_user.user_profile
    end

    def edit
      @profile = current_user.user_profile
    end

    def update
      @profile = current_user.user_profile
      if @profile.update(profile_params)
        redirect_to mentor_profile_path, notice: "Profile updated successfully."
      else
        render :edit
      end
    end

    private

  def profile_params
    params.require(:user_profile).permit(:full_name, :title, :organization, :years_experience, :bio, :mentorship_approach, :motivation, sectors: [], expertise: [], stage_preference: [], preferred_mentorship_mode: :availability_hours_month, :rate_per_hour, :pro_bono, :linkedin_url, :professional_website)
  end
end