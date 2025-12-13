class MentorApplication < ApplicationRecord
  enum :experience_years, [:under_three, :three_five, :six_ten, :over_ten]
  enum :preferred_stages, [:idea, :early, :growth, :scaling]
  enum :availability_hours, [:up_to_2_weekly, :monthly_3_5, :monthly_6_10, :monthly_10_plus, :flexible]
  enum :mode, [:virtual, :in_person, :both]
  enum :status, [:pending, :approved, :rejected]

  serialize :industries, coder: JSON
  serialize :mentorship_topics, coder: JSON

  validates :full_name, :email, :short_bio, :current_role, :experience_years, :organization, :industries, :mentorship_topics, :preferred_stages, :availability_hours, :approach, :motivation, :mode, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :rate, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
