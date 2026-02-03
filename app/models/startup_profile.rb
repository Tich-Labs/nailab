
class StartupProfile < ApplicationRecord
  has_one_attached :logo
  attr_accessor :onboarding_step

  before_validation :set_slug
  validate :ensure_slug, prepend: true
  validates :slug, presence: true, uniqueness: true, unless: -> { Rails.env.test? }

  belongs_to :user

  validates :startup_name, :description, :stage, :target_market, :value_proposition, presence: true
  validates :sector, presence: true, if: :validate_sector_and_funding_stage?
  validates :funding_stage, presence: true, if: :validate_sector_and_funding_stage?
  validates :website_url, :logo_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true, message: "must be a valid URL" }
  validate :validate_logo_size_if_present

  # Dropdown options (DRY principle)
  STAGE_OPTIONS = [
    "Pre-Launch",
    "MVP",
    "Early Traction",
    "Growth",
    "Scaling",
    "Mature"
  ].freeze

  SECTOR_OPTIONS = [
    "FinTech",
    "AgriTech",
    "HealthTech",
    "EdTech",
    "Supply Chain",
    "E-Commerce",
    "SaaS",
    "ClimTech",
    "Other"
  ].freeze

  FUNDING_STAGE_OPTIONS = [
    "Bootstrapped",
    "Angel",
    "Seed",
    "Series A",
    "Series B",
    "Series C+",
    "Acquired"
  ].freeze

  MARKET_OPTIONS = [
    "Local (Single Country)",
    "Regional (Africa)",
    "Global"
  ].freeze

  def validate_sector_and_funding_stage?
    # Only require sector and funding_stage if onboarding_step is 'confirm' (review step) or not set (normal edit)
    onboarding_step.blank? || onboarding_step.to_s == "confirm"
  end

  def to_param
    slug.presence || super
  end

  def public_viewable?
    profile_visibility?
  end

  # Return the configured `team_size` when present, otherwise fall back
  # to the associated startup's computed `team_size` (which treats the
  # founder as size 1 when there are no explicit team members).
  def team_size
    ts = read_attribute(:team_size).to_i
    return ts if ts.positive?
    if user && user.startups.any?
      return user.startups.first.team_size.to_i
    end
    0
  end

  def rails_admin_preview_path
    "/startups"
  end

  private

  def set_slug
    return if slug.present?

    base = (startup_name.presence || SecureRandom.hex(4)).to_s.parameterize
    candidate = base
    suffix = 2

    while self.class.unscoped.where(slug: candidate).exists?
      # append numeric suffix on collisions
      candidate = "#{base}-#{suffix}"
      suffix += 1
    end
    self.slug = candidate
  end

  def ensure_slug
    set_slug if slug.blank?
  end

  def validate_logo_size_if_present
    return unless logo.attached?

    # Check file size (max 5MB)
    if logo.blob.byte_size > 5.megabytes
      errors.add(:logo, "must be less than 5MB")
    end

    # Check file type
    unless logo.blob.content_type.in?(%w[image/jpeg image/png image/webp])
      errors.add(:logo, "must be a JPEG, PNG, or WebP image")
    end
  end
end
