class SupportTicketReply < ApplicationRecord
  belongs_to :support_ticket
  belongs_to :user, polymorphic: true, optional: true

  validates :body, presence: true

  def admin_reply?
    user.nil? || user != support_ticket.user
  end
end
