class Founder::MentorshipRequestsController < Founder::BaseController
  before_action :set_request, only: %i[show]

  def index
    @requests = current_user.mentorship_requests
  end

  def new
    @mentor = UserProfile.find_by(id: params[:mentor_id], role: 'mentor') if params[:mentor_id]
    @request = current_user.mentorship_requests.build(mentor_id: @mentor&.user_id)
  end

  def show
  end

  def create
    @request = current_user.mentorship_requests.build(mentorship_request_params)
    if @request.save
      redirect_to founder_mentorship_requests_path, notice: 'Request sent.'
    else
      redirect_back fallback_location: founder_mentorship_path, alert: 'Error.'
    end
  end

  private

  def set_request
    @request = current_user.mentorship_requests.find(params[:id])
  end

  def mentorship_request_params
    params.require(:mentorship_request).permit(:mentor_id, :message)
  end
end