class Mentor < ApplicationRecord
    before_validation :set_slug
    validates :slug, presence: true, uniqueness: true

    def to_param
      slug.presence || super
    end

    private

    def set_slug
      return unless slug.blank?

      base = (full_name || user&.email || id.to_s).parameterize
      candidate = base
      counter = 2
      while self.class.where(slug: candidate).where.not(id: id).exists?
        candidate = "#{base}-#{counter}"
        counter += 1
      end
      self.slug = candidate
    end
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
