module Founder
  class StartupInvitesController < Founder::BaseController
    before_action :ensure_signed_in
    before_action :set_startup

    def new
      @invite = StartupInvite.new(startup: @startup, inviter: current_user)
    end

    def create
      # Normalize role param to one of the allowed enum keys to avoid ArgumentError
      raw_role = params.dig(:startup_invite, :role).to_s.downcase.strip
      role = StartupInvite.roles.key?(raw_role) ? raw_role : 'member'

      @invite = @startup.startup_invites.build(invite_params.merge(inviter: current_user, role: role))

      if @invite.save
        InviteMailer.invite_email(@invite.id).deliver_later
        @invite.mark_sent!
        respond_to do |format|
          format.html { redirect_to founder_startup_profile_path, notice: "Invitation sent." }
          format.json { render json: { success: true, id: @invite.id }, status: :created }
        end
      else
        respond_to do |format|
          format.html do
            flash.now[:alert] = @invite.errors.full_messages.join(", ")
            render :new, status: :unprocessable_entity
          end
          format.json { render json: { success: false, errors: @invite.errors.full_messages }, status: :unprocessable_entity }
        end
      end
    end

    private

    def set_startup
      startup_id = params[:startup_id] || params.dig(:startup, :id) || params[:id] || params.dig(:startup_invite, :startup_id)

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
