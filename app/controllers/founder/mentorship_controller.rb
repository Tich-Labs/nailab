class Founder::MentorshipController < Founder::BaseController

  def index
    @mentors = Mentor.all
    @mentorship_requests = current_user.mentorship_requests
    @sessions = current_user.sessions
    
    # Handle mentorship request modal
    if params[:request_mentor].present?
      @selected_mentor = Mentor.find_by(id: params[:request_mentor])
      @mentorship_request = current_user.mentorship_requests.build(mentor: @selected_mentor)
    end
  end
end