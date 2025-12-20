require "test_helper"

class SupportTicketMailerTest < ActionMailer::TestCase
  test "new_support_ticket" do
    support_ticket = support_tickets(:one)
    mail = SupportTicketMailer.with(support_ticket: support_ticket).new_support_ticket

    assert_equal "New support ticket from #{support_ticket.user.name}", mail.subject
    assert_equal [ ENV.fetch("SUPPORT_EMAIL", "support@nailab.com") ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match support_ticket.description, mail.body.encoded
  end
end
