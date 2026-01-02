class StartupProfile < ApplicationRecord
  before_validation :set_slug
  validate :ensure_slug, prepend: true
  validates :slug, presence: true, uniqueness: true, unless: -> { Rails.env.test? }

  belongs_to :user

  validates :startup_name, :description, :stage, :sector, :target_market, :value_proposition, presence: true
  validates :funding_stage, presence: true
  validates :website_url, :logo_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true, message: "must be a valid URL" }

  def to_param
    slug.presence || super
  end

  def public_viewable?
    profile_visibility?
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
end
