class OnboardingSubmission < ApplicationRecord
  has_secure_token :token

  belongs_to :user, optional: true

  ROLES = %w[founder mentor partner].freeze

  validates :role, inclusion: { in: ROLES }
  validates :email, presence: true
  validates :payload, presence: true

  def apply_to_user!
    raise "Already applied" if applied_at.present?
    raise "Missing user" if user.blank?

    case role
    when "mentor"
      apply_mentor!
    when "founder"
      apply_founder!
    when "partner"
      apply_partner!
    else
      raise "Unsupported role: #{role.inspect}"
    end

    update!(applied_at: Time.current)
  end

  def self.apply_for_confirmed_user!(user)
    submission = where(user_id: user.id, applied_at: nil).order(created_at: :desc).first
    submission&.apply_to_user!
  end

  private

  def apply_mentor!
    attrs = (payload["user_profile"] || payload[:user_profile] || payload).to_h

    years_experience = attrs["years_experience"] || attrs[:years_experience]
    years_experience = normalize_years_experience(years_experience)

    profile_attrs = attrs.slice(
      "full_name",
      "title",
      "bio",
      "linkedin_url",
      "professional_website",
      "organization",
      "advisory_experience",
      "advisory_description",
      "sectors",
      "expertise",
      "stage_preference",
      "mentorship_approach",
      "motivation",
      "availability_hours_month",
      "preferred_mentorship_mode",
      "currency",
      "rate_per_hour",
      "pro_bono"
    ).merge(
      "role" => "mentor",
      "years_experience" => years_experience,
      "onboarding_completed" => true
    )

    profile = user.user_profile || user.build_user_profile
    profile.assign_attributes(profile_attrs)
    profile.save!
  end

  def apply_founder!
    user_profile_attrs = (payload["user_profile"] || {}).to_h
    startup_profile_attrs = (payload["startup_profile"] || {}).to_h

    profile = user.user_profile || user.build_user_profile
    profile.assign_attributes(user_profile_attrs.merge("role" => "founder", "onboarding_completed" => true))
    profile.save!

    startup = user.startup_profile || user.build_startup_profile
    startup.assign_attributes(startup_profile_attrs)
    startup.save!
  end

  def apply_partner!
    contact_name = payload.dig("partner_application", "contact_name") || payload.dig("partner_application", :contact_name)

    profile = user.user_profile || user.build_user_profile
    profile.assign_attributes(
      "role" => "partner",
      "full_name" => contact_name,
      "onboarding_completed" => true
    )
    profile.save!

    partner_application_id = payload.dig("partner_application", "id") || payload.dig("partner_application", :id)
    if partner_application_id.present?
      partner_application = PartnerApplication.find_by(id: partner_application_id)
      partner_application&.update!(user_id: user.id)
    end
  end

  def normalize_years_experience(value)
    return value if value.is_a?(Integer)

    case value.to_s
    when "<3"
      2
    when "3-5"
      4
    when "6-10"
      8
    when "10+"
      10
    else
      nil
    end
  end
end
