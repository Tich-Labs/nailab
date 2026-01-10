module MentorPortal
  class ProfilesController < MentorPortal::BaseController
    def show
      @mentor = current_mentor
      @mentor_profile = current_user.user_profile || current_user.build_user_profile
    end

    def edit
      @mentor = current_mentor
      @mentor_profile = current_user.user_profile || current_user.build_user_profile
    end

    def update
      @mentor = current_mentor
      @mentor_profile = current_user.user_profile || current_user.build_user_profile

      success = true

      if params[:mentor]
        success &= @mentor.update(params.require(:mentor).permit(:title, :expertise, :photo))
      end

      if params[:mentor_profile]
        profile_attrs = params.require(:mentor_profile).permit(:full_name, :bio, :location, :city, :country, :professional_website)
        success &= @mentor_profile.update(profile_attrs)
      end

      respond_to do |format|
        if success
          format.html { redirect_to mentor_profile_path, notice: "Profile updated successfully." }
          format.js { render json: { message: "Profile updated successfully." }, status: :ok }
        else
          format.html { render :edit }
          format.js { render json: { errors: (@mentor_profile&.errors&.full_messages || []) + (@mentor.errors.full_messages || []) }, status: :unprocessable_entity }
        end
      end
    end

    private

    def mentor_params
      params.require(:mentor).permit(:name, :title, :bio, :expertise, :photo)
    end
  end
end
