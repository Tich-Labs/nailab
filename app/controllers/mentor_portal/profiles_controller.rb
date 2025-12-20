module MentorPortal
  class ProfilesController < MentorPortal::BaseController
    def show
      @mentor = current_mentor
    end

    def edit
      @mentor = current_mentor
    end

    def update
      @mentor = current_mentor
      if @mentor.update(mentor_params)
        redirect_to mentor_profile_path, notice: "Profile updated successfully."
      else
        render :edit
      end
    end

    private

    def mentor_params
      params.require(:mentor).permit(:name, :title, :bio, :expertise, :photo)
    end
  end
end