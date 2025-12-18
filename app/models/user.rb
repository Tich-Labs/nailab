class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
  has_one :user_profile, dependent: :destroy
  has_one :startup_profile, dependent: :destroy
  has_one :startup, dependent: :destroy
  has_many :milestones, dependent: :destroy
  has_many :monthly_metrics, dependent: :destroy
  has_many :mentorship_requests, foreign_key: :founder_id, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :conversations, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_one :subscription, dependent: :destroy
  has_many :connections, dependent: :destroy
  has_many :peer_messages, foreign_key: :sender_id, dependent: :destroy
  has_many :received_peer_messages, class_name: 'PeerMessage', foreign_key: :recipient_id, dependent: :destroy
end
