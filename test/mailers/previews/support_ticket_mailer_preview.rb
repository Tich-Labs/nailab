# Preview all emails at http://localhost:3000/rails/mailers/support_ticket_mailer
class SupportTicketMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/support_ticket_mailer/new_support_ticket
  def new_support_ticket
    user = User.new(email: 'preview-founder@example.com')
    support_ticket = SupportTicket.new(
      user: user,
      subject: 'Preview issue',
      category: 'Technical Issue',
      description: 'This is a preview of the support ticket notification.',
      status: 'open'
    )
    SupportTicketMailer.with(support_ticket: support_ticket).new_support_ticket
  end
end
