module Founder
  class StartupInvitesController < Founder::BaseController
    before_action :ensure_signed_in
    before_action :set_startup

    def new
      @invite = StartupInvite.new(startup: @startup, inviter: current_user)
    end

    def create
      @invite = @startup.startup_invites.build(invite_params.merge(inviter: current_user))

      if @invite.save
        InviteMailer.invite_email(@invite.id).deliver_later
        @invite.mark_sent!
        render json: { success: true, id: @invite.id }, status: :created
      else
        render json: { success: false, errors: @invite.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def set_startup
      startup_id = params[:startup_id] || params.dig(:startup, :id) || params[:id]

      if startup_id.present?
        @startup = current_user.startups.find(startup_id)
      else
        raise ActiveRecord::RecordNotFound
      end
    rescue ActiveRecord::RecordNotFound
      if request.format.json?
        render json: { error: "Startup not found" }, status: :not_found
      else
        redirect_to founder_startup_profile_path, alert: "Startup not found or not accessible."
      end
    end

    def invite_params
      params.require(:startup_invite).permit(:invitee_name, :invitee_email, :role)
    end
  end
end
