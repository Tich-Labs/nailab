class UserProfile < ApplicationRecord
  belongs_to :user

  # Validations
  validates :full_name, presence: true, if: -> { role == "mentor" }
  validates :title, presence: true, if: -> { role == "mentor" }
  validates :bio, presence: true, length: { minimum: 50, maximum: 1000 }, if: -> { role == "mentor" }
  validates :organization, presence: true, if: -> { role == "mentor" }
  validates :years_experience, presence: true, if: -> { role == "mentor" }
  validates :linkedin_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp }, if: -> { role == "mentor" }
  validates :mentorship_approach, presence: true, length: { minimum: 150, maximum: 800 }, if: -> { role == "mentor" }
  validates :motivation, presence: true, length: { minimum: 50, maximum: 500 }, if: -> { role == "mentor" }
  validates :sectors, presence: true, if: -> { role == "mentor" }
  validates :expertise, presence: true, if: -> { role == "mentor" }
  validates :stage_preference, presence: true, if: -> { role == "mentor" }
  validates :preferred_mentorship_mode, presence: true, if: -> { role == "mentor" }
  validates :availability_hours_month, presence: true, if: -> { role == "mentor" }
  validates :professional_website, format: { with: URI::DEFAULT_PARSER.make_regexp }, allow_blank: true

  # Custom validation for pro bono vs rate
  validate :rate_or_pro_bono, if: -> { role == "mentor" }

  private

  def rate_or_pro_bono
    if pro_bono == false && rate_per_hour.blank?
      errors.add(:rate_per_hour, "must be set if not offering pro bono mentoring")
    end
  end
end
