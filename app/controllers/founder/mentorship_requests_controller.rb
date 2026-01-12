class Founder::MentorshipRequestsController < Founder::BaseController
  before_action :set_request, only: %i[show edit update destroy]

  def index
    # Ensure the view always has a collection to iterate over
    @mentorship_requests = current_user.mentorship_requests || []
  end

  def new
    if params[:mentor_id].present?
      mentor = Mentor.find_by(id: params[:mentor_id])
      @mentor = mentor
      @request = current_user.mentorship_requests.build(mentor_id: mentor&.user_id)
    else
      @request = current_user.mentorship_requests.build
    end
  end

  def show
  end

  def edit
  end

  def update
    if @request.update(mentorship_request_params)
      redirect_to founder_mentorship_requests_path, notice: "Request updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @request.destroy
    redirect_to founder_mentorship_requests_path, notice: "Request deleted."
  end

  def create
    @request = current_user.mentorship_requests.build(mentorship_request_params)
    if @request.save
      redirect_to founder_mentorship_requests_path, notice: "Request sent."
    else
      redirect_back fallback_location: founder_mentorship_path, alert: "Error."
    end
  end

  private

  def set_request
    @request = current_user.mentorship_requests.find(params[:id])
    # some views expect `@mentorship_request` variable name
    @mentorship_request = @request
  end

  def mentorship_request_params
    params.require(:mentorship_request).permit(:mentor_id, :message, :proposed_time)
  end
end
