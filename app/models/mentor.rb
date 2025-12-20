class Mentor < ApplicationRecord
  belongs_to :user

  delegate :organization, to: :user_profile, prefix: false, allow_nil: true
  delegate :full_name, to: :user_profile, prefix: false, allow_nil: true
  delegate :bio, to: :user_profile, prefix: false, allow_nil: true
  delegate :title, to: :user_profile, prefix: false, allow_nil: true
  delegate :years_experience, to: :user_profile, prefix: false, allow_nil: true
  delegate :expertise, to: :user_profile, prefix: false, allow_nil: true
  delegate :sectors, to: :user_profile, prefix: false, allow_nil: true
  delegate :availability_hours_month, to: :user_profile, prefix: false, allow_nil: true
  delegate :preferred_mentorship_mode, to: :user_profile, prefix: false, allow_nil: true
  delegate :rate_per_hour, to: :user_profile, prefix: false, allow_nil: true
  delegate :pro_bono, to: :user_profile, prefix: false, allow_nil: true
  delegate :mentorship_approach, to: :user_profile, prefix: false, allow_nil: true
  delegate :motivation, to: :user_profile, prefix: false, allow_nil: true
  delegate :stage_preference, to: :user_profile, prefix: false, allow_nil: true
  delegate :linkedin_url, to: :user_profile, prefix: false, allow_nil: true
  delegate :professional_website, to: :user_profile, prefix: false, allow_nil: true
  delegate :photo, to: :user_profile, prefix: false, allow_nil: true

  alias_method :company, :organization
  alias_method :name, :full_name
  alias_method :specialties, :expertise
  alias_method :industries, :sectors
  alias_method :availability, :availability_hours_month

  def role
    "Mentor"
  end

  private

  def user_profile
    user&.user_profile
  end
end
