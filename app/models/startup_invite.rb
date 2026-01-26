class StartupInvite < ApplicationRecord
  belongs_to :startup
  belongs_to :inviter, class_name: "User"

  validates :invitee_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :token, presence: true, uniqueness: true

  before_validation :generate_token, on: :create

  def mark_sent!
    update(sent_at: Time.current)
  end

  def mark_accepted!(user = nil)
    update(accepted_at: Time.current)
    # Optionally associate the accepted user to the startup via Connection
    if user
      Connection.create(user: inviter, peer: user)
      Notification.create(user: user, title: "You've joined #{startup.name}", message: "You were added to #{startup.name} by #{inviter.name}", link: "/startups/#{startup.id}")
    end
  end

  private

  def generate_token
    self.token ||= SecureRandom.urlsafe_base64(24)
  end
end
