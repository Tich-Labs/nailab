class SupportTicketMailer < ApplicationMailer
  default to: -> { ENV.fetch("SUPPORT_EMAIL", "support@nailab.com") }

  def new_support_ticket
    @support_ticket = params[:support_ticket]
    mail(subject: "New support ticket from #{@support_ticket.user.name}")
  end
end
