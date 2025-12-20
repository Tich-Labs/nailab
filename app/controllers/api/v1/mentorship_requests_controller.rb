module Api
  module V1
    class MentorshipRequestsController < PublicController
      def index
        role = params[:role]
        user_id = params[:user_id]

        unless %w[mentor founder].include?(role) && user_id.present?
          return render json: { error: "role and user_id are required" }, status: :bad_request
        end

        requests = base_scope(role, user_id)
          .order(created_at: :desc)
          .includes(founder: :user_profile, mentor: :user_profile)

        render_collection(requests, Serializers::MentorshipRequestSerializer)
      end

      def create
        request = MentorshipRequest.create!(mentorship_request_params.merge(status: "pending"))
        notify_user(
          user_id: request.mentor_id,
          title: "New Mentorship Request",
          message: "You received a mentorship request from #{request.founder.user_profile&.full_name}",
          link: "/dashboard"
        )
        render json: serialize_request(request), status: :created
      end

      def respond
        request = MentorshipRequest.find(params[:id])
        required_status = params[:status]
        unless %w[accepted declined reschedule_requested].include?(required_status)
          return render json: { error: "status must be accepted, declined, or reschedule_requested" }, status: :bad_request
        end

        case required_status
        when "accepted"
          request.accept!
          MentorshipConnection.find_or_create_by!(founder_id: request.founder_id, mentor_id: request.mentor_id, mentorship_request_id: request.id) do |connection|
            connection.status = "active"
          end
        when "declined"
          request.decline!(reason: params[:decline_reason])
        when "reschedule_requested"
          proposed_time = parse_datetime(params[:proposed_time])
          if proposed_time.nil?
            return render json: { error: "proposed_time is required for reschedule" }, status: :bad_request
          end
          request.propose_reschedule!(proposed_time: proposed_time, reason: params[:reschedule_reason])
        end

        notify_user(
          user_id: request.founder_id,
          title: "Mentorship Request #{required_status.capitalize}",
          message: "Your request has been #{required_status}",
          link: "/dashboard"
        )

        render json: serialize_request(request)
      end

      private

      def base_scope(role, user_id)
        case role
        when "mentor"
          MentorshipRequest.where(mentor_id: user_id)
        when "founder"
          MentorshipRequest.where(founder_id: user_id)
        end
      end

      def mentorship_request_params
        params.permit(:founder_id, :mentor_id, :message, :reschedule_reason, :proposed_time)
      end

      def parse_datetime(value)
        return if value.blank?
        Time.zone.parse(value)
      rescue ArgumentError
        nil
      end

      def notify_user(user_id:, title:, message:, link: nil)
        Notification.create!(
          user_id: user_id,
          notif_type: "request",
          title: title,
          message: message,
          link: link
        )
      end

      def serialize_request(request)
        Serializers::MentorshipRequestSerializer.new(request).to_h
      end
    end
  end
end
