class SupportTicket < ApplicationRecord
  belongs_to :user
  has_many :replies, class_name: "SupportTicketReply", dependent: :destroy

  enum :status, { open: "open", in_progress: "in_progress", resolved: "resolved", closed: "closed" }

  validates :subject, :description, presence: true

  # Create initial reply when ticket is created
  after_create :create_initial_reply

  def add_admin_reply(message, admin_user)
    replies.create!(user: admin_user, body: message)
  end

  private

  def create_initial_reply
    replies.create!(
      user: user,
      body: description
    )
  end
end
