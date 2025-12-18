class Founder::MentorshipController < Founder::BaseController

  def index
    @mentors = Mentor.all
    @mentorship_requests = current_user.mentorship_requests
    @sessions = current_user.sessions
  end
end