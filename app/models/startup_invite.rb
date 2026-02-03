class StartupInvite < ApplicationRecord
  belongs_to :startup
  belongs_to :inviter, class_name: "User"

  validates :invitee_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :token, presence: true, uniqueness: true
  validate :invitee_not_already_member
  validate :no_duplicate_pending_invites

  before_validation :generate_token, on: :create

  # Scopes for common queries
  scope :pending, -> { where(accepted_at: nil) }
  scope :accepted, -> { where.not(accepted_at: nil) }
  scope :sent, -> { where.not(sent_at: nil) }
  scope :expired, -> { where("created_at < ?", 30.days.ago).where(accepted_at: nil) }

  enum :role, { member: 0, admin: 1, owner: 2 }

  def mark_sent!
    update(sent_at: Time.current)
  end

  def mark_accepted!(user = nil)
    return if accepted_at.present? # Already accepted

    update(accepted_at: Time.current)

    # Add accepted user to startup team if user provided
    if user
      TeamMember.find_or_create_by!(
        startup: startup,
        user: user
      ) do |tm|
        tm.role = role
      end

      # Create connection for networking
      Connection.create(user: inviter, peer: user)

      # Notify user
      Notification.create(
        user: user,
        title: "You've joined #{startup.name}",
        message: "You were added to #{startup.name} by #{inviter.name}",
        link: "/startups/#{startup.id}"
      )
    end
  end

  def expired?
    created_at < 30.days.ago && accepted_at.blank?
  end

  def accept_as_user(user)
    return false unless user.email.downcase == invitee_email.downcase
    mark_accepted!(user)
    true
  rescue => e
    Rails.logger.error("Error accepting invite: #{e.message}")
    false
  end

  private

  def generate_token
    self.token ||= SecureRandom.urlsafe_base64(24)
  end

  def invitee_not_already_member
    return if invitee_email.blank?

    user = User.find_by("LOWER(email) = ?", invitee_email.downcase)
    if user && startup.has_team_member?(user)
      errors.add(:invitee_email, "is already a member of this startup")
    end
  end

  def no_duplicate_pending_invites
    return if invitee_email.blank?

    if startup.startup_invites.pending.exists?("LOWER(invitee_email) = ?", invitee_email.downcase)
      errors.add(:invitee_email, "has already been invited to this startup")
    end
  end
end
