class UserProfile < ApplicationRecord
    before_validation :set_slug, on: :create
    validates :slug, presence: true, uniqueness: true

    def to_param
      slug.presence || super
    end
    def to_param
      slug.presence || super
    end
  belongs_to :user
  has_one_attached :photo

  validate :photo_type_and_size

  enum :profile_approval_status, { pending: "pending", approved: "approved", rejected: "rejected" }

  # Approve the profile and notify the owner
  def approve!(actor: nil)
    transaction do
      update!(profile_approval_status: :approved, profile_rejection_reason: nil)
      ProfileApprovalMailer.with(user_profile: self).approved.deliver_later
      ProfileAudit.create!(user_profile: self, admin: actor, action: "approved")
    end
  end

  # Reject the profile with a reason and notify the owner
  def reject!(reason:, actor: nil)
    transaction do
      update!(profile_approval_status: :rejected, profile_rejection_reason: reason)
      ProfileApprovalMailer.with(user_profile: self, reason: reason).rejected.deliver_later
      ProfileAudit.create!(user_profile: self, admin: actor, action: "rejected", reason: reason)
    end
  end

  # Validations
  # Require a full name for all users (founders and mentors). Onboarding relies
  # on `full_name` being present for founders, so make it server-enforced.
  validates :full_name, presence: true

  # Founders (non-mentor) must provide basic contact/location details collected
  # during onboarding. Mentors have their own stricter validations below.
  validates :phone, presence: true, unless: -> { role == "mentor" }
  validates :country, presence: true, unless: -> { role == "mentor" }

  # Mentor-specific validations (kept as before)
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

  # Founder-specific bio requirement: shorter minimum than mentors but still
  # require founders to include a brief bio during onboarding.
  validates :bio, presence: true, length: { minimum: 30, maximum: 1000 }, unless: -> { role == "mentor" }

  # Custom validation for pro bono vs rate (mentor-only)
  validate :rate_or_pro_bono, if: -> { role == "mentor" }

  private

  def photo_type_and_size
    return unless photo.attached?

    if !photo.content_type&.start_with?("image/")
      errors.add(:photo, "must be an image")
    end

    if photo.byte_size > 5.megabytes
      errors.add(:photo, "must be smaller than 5MB")
    end
  end

  def rate_or_pro_bono
    if pro_bono == false && rate_per_hour.blank?
      errors.add(:rate_per_hour, "must be set if not offering pro bono mentoring")
    end
  end

  def set_slug
    self.slug ||= (full_name || user&.email || id.to_s).parameterize if slug.blank?
  end
end
