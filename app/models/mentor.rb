class Mentor < ApplicationRecord
  has_many :mentorship_requests

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :bio, presence: true, length: { maximum: 500 }
  validates :expertise, presence: true

  # New validations for expanded fields
  validates :years_experience, :availability_hours_per_month, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :hourly_rate, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :linkedin_url, :website_url, format: URI::regexp(%w[http https]), allow_blank: true
  validates :preferred_stage, inclusion: { in: %w[Idea Early Growth Scaling] }, allow_blank: true
  validates :mentorship_mode, inclusion: { in: %w[Virtual In-Person Both] }, allow_blank: true
end
