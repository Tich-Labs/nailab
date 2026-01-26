class InviteMailer < ApplicationMailer
  default from: ENV.fetch("DEFAULT_FROM_EMAIL", "noreply@nailab.example")

  def invite_email(invite_id)
    @invite = StartupInvite.find(invite_id)
    @startup = @invite.startup
    @inviter = @invite.inviter
    @accept_url = accept_invites_url(token: @invite.token)

    mail(to: @invite.invitee_email, subject: "You're invited to join #{@startup.name} on Nailab")
  end
end
