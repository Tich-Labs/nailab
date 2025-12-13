class MentorshipRequest < ApplicationRecord
  belongs_to :user
  belongs_to :mentor, optional: true

  enum :request_type, { one_time: "one_time", ongoing: "ongoing" }
  enum :status, { pending: "pending", approved: "approved", rejected: "rejected" }

  # Validations for one-time mentorship
  with_options if: :one_time? do
    validates :topic, presence: true
    validates :date, presence: true
    validates :goal, presence: true, length: { maximum: 1000 }
  end

  # Validations for ongoing mentorship
  with_options if: :ongoing? do
    validates :user_id, uniqueness: { scope: :request_type, message: "already has a long-term request" }
    validates :full_name, presence: true
    validates :phone_number, presence: true
    validates :startup_name, presence: true
    validates :startup_bio, presence: true, length: { maximum: 1000 }
    validates :startup_stage, presence: true
    validates :startup_industry, presence: true
    validates :funding_structure, presence: true
    validates :mentorship_needs, presence: true, length: { maximum: 1000 }
    validates :target_market, presence: true
    validates :preferred_mentorship_mode, presence: true
  end

  validates :request_type, presence: true
  validates :status, presence: true
end
