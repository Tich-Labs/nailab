class User < ApplicationRecord
    # Role enumeration for better security and maintainability
    enum :role, {
      founder: 0,
      mentor: 1,
      partner: 2,
      admin: 3
    }, default: :founder

    before_validation :set_slug
    validates :slug, presence: true, uniqueness: true

    def to_param
      slug.presence || super
    end

    private

    def set_slug
      return unless slug.blank?

      base = (full_name || email || id.to_s).parameterize
      candidate = base
      counter = 2
      while self.class.where(slug: candidate).where.not(id: id).exists?
        candidate = "#{base}-#{counter}"
        counter += 1
      end
      self.slug = candidate
    end
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
  # Enforce stronger password complexity in addition to Devise's length checks.
  validate :password_complexity, if: -> { password.present? }
  has_one :user_profile, dependent: :destroy
  has_one :startup_profile, dependent: :destroy
  has_many :startups, dependent: :destroy
  has_many :team_members, dependent: :destroy
  has_many :team_startups, through: :team_members, source: :startup
  has_one :mentor, dependent: :destroy
  has_many :milestones, dependent: :destroy
  has_many :monthly_metrics, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :mentorship_requests, foreign_key: :founder_id, dependent: :destroy
  has_many :received_mentorship_requests, class_name: "MentorshipRequest", foreign_key: :mentor_id, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :conversations, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_one :subscription, dependent: :destroy
  has_many :connections, dependent: :destroy
  has_many :peer_messages, foreign_key: :sender_id, dependent: :destroy
  has_many :received_peer_messages, class_name: "PeerMessage", foreign_key: :recipient_id, dependent: :destroy
  has_many :identities, dependent: :destroy
  has_many :support_tickets, dependent: :destroy
  has_many :support_ticket_replies, as: :user, dependent: :destroy

  # Callback to initialize subscription on user creation
  after_create :create_initial_subscription!

  public

  delegate :full_name, to: :user_profile, prefix: false, allow_nil: true

  # Convenience accessor for a user's primary startup (first created)
  # Many controllers expect `current_user.startup` to return a single startup.
  def startup
    startups.first
  end

  def name
    full_name || email
  end

  # Role helper methods for better readability
  def founder?
    role == "founder"
  end

  def mentor?
    role == "mentor"
  end

  def partner?
    role == "partner"
  end

  def admin?
    role == "admin" || admin == true
  end

  # Subscription & trial helpers
  def trial_active?
    subscription&.trial_active? || false
  end

  def subscription_valid?
    subscription&.can_access_resources? || false
  end

  def trial_days_remaining
    subscription&.days_remaining || 0
  end

  def premium_resources_accessible?
    subscription&.can_access_resources? || false
  end

  def create_initial_subscription!
    return if subscription.present?
    Subscription.create!(user: self, status: :trial, trial_started_at: Time.current, trial_days: 5)
  rescue => e
    Rails.logger.error("Failed to create initial subscription for user #{id}: #{e.message}")
  end

  # Counts how many startups the user has created (founder count)
  def founder_startup_count
    startups.count
  end

  # Team size for the user's primary startup (includes the founder themselves).
  # Returns 0 if the user has no startups, otherwise at least 1.
  def primary_startup_team_size
    s = startup
    return 0 unless s
    s.team_size
  end
  # Check if user has any elevated privileges
  def privileged?
    admin? || mentor?
  end

  # Delegate common profile attributes so views can call `user.expertise`,
  # `user.bio`, etc., directly. Allow nil to avoid NoMethodError when
  # profile is not present.
  delegate :organization, :bio, :title, :years_experience, :expertise, :sectors,
           :availability_hours_month, :preferred_mentorship_mode, :rate_per_hour,
           :pro_bono, :mentorship_approach, :motivation, :stage_preference,
           :linkedin_url, :professional_website, :photo,
           to: :user_profile, allow_nil: true

  # Enhanced password reset with SendGrid integration
  def send_password_reset_instructions_with_sendgrid(token, options = {})
    token, encoded = Devise.token_generator.generate(self, :reset_password_token)

    Devise::Mailer.send_reset_password_instructions(self, token, encoded).deliver_now
    Rails.logger.info "Password reset email sent via SendGrid to #{self.email}"
  rescue => e
    Rails.logger.error "SendGrid password reset failed: #{e.message}"
    raise e
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.role = auth.credentials.role if auth.credentials&.role

      # Create user profile with LinkedIn data
      user.build_user_profile(
        full_name: auth.info.first_name && auth.info.last_name ? "#{auth.info.first_name} #{auth.info.last_name}" : auth.info.name,
        linkedin_url: auth.info.urls&.public_profile,
        bio: auth.info.description&.truncate(500),
        photo_url: auth.info.image
      )
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.linkedin_data"]
        user.email = data["info"]["email"] if user.email.blank?
        user.build_user_profile if user.user_profile.blank?
        user.user_profile.full_name = "#{data['info']['first_name']} #{data['info']['last_name']}" if user.user_profile.full_name.blank?
        user.user_profile.linkedin_url = data["info"]["urls"]["public_profile"] if data["info"]["urls"]
      end
    end
  end

  private

  def password_complexity
    return if password.blank?

    missing = []
    missing << "one lowercase letter" unless password =~ /[a-z]/
    missing << "one uppercase letter" unless password =~ /[A-Z]/
    missing << "one digit" unless password =~ /\d/
    missing << "one special character (e.g. !@#$%^&*)" unless password =~ /[^A-Za-z0-9]/

    if missing.any?
      errors.add(:password, "must include at least #{missing.to_sentence}")
    end
  end
end
