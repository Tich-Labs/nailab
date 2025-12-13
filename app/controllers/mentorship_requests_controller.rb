class MentorshipRequestsController < ApplicationController
  before_action :authenticate_user!

  def new_one_time
    @mentorship_request = current_user.mentorship_requests.build(request_type: :one_time)
  end

  def new_ongoing
    @mentorship_request = current_user.mentorship_requests.build(request_type: :ongoing)
  end

  def create
    @mentorship_request = current_user.mentorship_requests.build(mentorship_request_params)

    if @mentorship_request.save
      redirect_to dashboard_path, notice: "Your mentorship request has been submitted! We'll review it and get back to you soon."
    else
      render @mentorship_request.one_time? ? :new_one_time : :new_ongoing
    end
  end

  private

  def mentorship_request_params
    params.require(:mentorship_request).permit(
      :request_type, :topic, :date, :goal, # one-time
      :full_name, :phone_number,
      :startup_name, :startup_bio,
      :startup_stage, :startup_industry,
      :funding_structure, :total_funding,
      :target_market, :mentorship_needs,
      :preferred_mentorship_mode,
      :top_mentorship_areas, :commitment_length
    )
  end
end
