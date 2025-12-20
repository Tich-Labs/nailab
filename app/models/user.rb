class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
  has_one :user_profile, dependent: :destroy
  has_one :startup_profile, dependent: :destroy
  has_one :startup, dependent: :destroy
  has_one :subscription, dependent: :destroy
  has_many :milestones, dependent: :destroy
  has_many :monthly_metrics, dependent: :destroy
  has_many :mentorship_requests, foreign_key: :founder_id, dependent: :destroy
  has_many :support_tickets, dependent: :destroy
  has_many :received_mentorship_requests, class_name: "MentorshipRequest", foreign_key: :mentor_id, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :conversations, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :baseline_plans, dependent: :destroy
  has_many :connections, dependent: :destroy
  has_many :peer_messages, foreign_key: :sender_id, dependent: :destroy
  has_many :received_peer_messages, class_name: "PeerMessage", foreign_key: :recipient_id, dependent: :destroy
  has_many :identities, dependent: :destroy

  delegate :full_name, :expertise, to: :user_profile, prefix: false, allow_nil: true

  def name
    full_name || email
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      # Create user profile with LinkedIn data
      user.build_user_profile(
        full_name: auth.info.name,
        linkedin_url: auth.info.urls&.public_profile,
        bio: auth.info.description
      )
    end
  end
end
