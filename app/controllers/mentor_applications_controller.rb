class MentorApplicationsController < ApplicationController
  def new
    linkedin_data = session.delete("mentor_application_linkedin_data")
    @mentor_application = MentorApplication.new(linkedin_data || {})
  end

  def create
    @mentor_application = MentorApplication.new(mentor_application_params)
    if @mentor_application.save
      redirect_to root_path, notice: "Your application has been submitted successfully. We'll review it and get back to you soon!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def mentor_application_params
    params.require(:mentor_application).permit(
      :full_name, :email, :short_bio, :current_role, :experience_years,
      :has_advisory_experience, :organization, :approach, :motivation,
      :preferred_stages, :availability_hours, :mode, :rate, :linkedin_url,
      industries: [], mentorship_topics: []
    )
  end
end
