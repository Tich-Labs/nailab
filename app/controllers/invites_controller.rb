class InvitesController < ApplicationController
  skip_before_action :ensure_signed_in, only: [ :accept ]

  def accept
    token = params[:token]
    invite = StartupInvite.find_by(token: token)

    if invite.nil?
      redirect_to root_path, alert: "Invalid or expired invite token."
      return
    end

    if user_signed_in?
      invite.mark_accepted!(current_user)
      redirect_to startup_path(invite.startup), notice: "You've joined #{invite.startup.name}."
    else
      # Store token in session and redirect to sign up/sign in flow
      session[:pending_invite_token] = token
      redirect_to new_user_registration_path, notice: "Please create an account to accept the invitation."
    end
  end
end
