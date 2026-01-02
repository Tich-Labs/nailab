module MentorPortal
  class MentorshipRequestsController < BaseController
    before_action :set_request, only: %i[show accept decline reschedule]

    def index
      @requests = MentorshipRequest.for_mentor(current_user.id).includes(founder: :user_profile)
    end

    def show
    end

    def accept
      @request.accept!
      ensure_connection
      notify_founder(:accepted, "Your mentorship request has been accepted.")
      redirect_to mentor_mentorship_requests_path, notice: "Mentorship request accepted."
    end

    def decline
      reason = params[:decline_reason].presence || "No reason provided."
      @request.decline!(reason: reason)
      notify_founder(:declined, "#{current_user.user_profile&.full_name} declined your request: #{reason}")
      redirect_to mentor_mentorship_requests_path, notice: "Mentorship request declined."
    end

    def reschedule
      proposed_time = parse_datetime(params[:proposed_time])
      if proposed_time.blank?
        redirect_to mentor_mentorship_requests_path, alert: "Please select a new date and time."
        return
      end

      reason = params[:reschedule_reason].presence || "Suggested a new time."
      @request.propose_reschedule!(proposed_time: proposed_time, reason: reason)
      notify_founder(:reschedule_requested, "#{current_user.user_profile&.full_name} suggested a new time: #{proposed_time.strftime('%b %d, %Y – %I:%M %p')}.")
      redirect_to mentor_mentorship_requests_path, notice: "Reschedule request sent to the founder."
    end

    private

    def set_request
      @request = MentorshipRequest.for_mentor(current_user.id).find(params[:id])
    end

    def parse_datetime(value)
      return if value.blank?
      Time.zone.parse(value)
    rescue ArgumentError
      nil
    end

    def ensure_connection
      MentorshipConnection.find_or_create_by!(founder_id: @request.founder_id, mentor_id: @request.mentor_id, mentorship_request_id: @request.id) do |connection|
        connection.status = "active"
      end
    end

    def notify_founder(status, message)
      Notification.create!(
        user_id: @request.founder_id,
        notif_type: "request",
        title: "Mentorship request #{status.to_s.humanize}",
        message: message,
        link: founder_mentorship_requests_path
      )
    end
  end
end
