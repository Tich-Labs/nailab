class StartupProfile < ApplicationRecord
  before_validation :set_slug, on: :create
  validates :slug, presence: true, uniqueness: true

  belongs_to :user

  validates :startup_name, :description, :stage, :sector, :target_market, :value_proposition, presence: true
  validates :funding_stage, presence: true
  validates :website_url, :logo_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true, message: 'must be a valid URL' }

  def to_param
    slug.presence || super
  end

  def public_viewable?
    profile_visibility?
  end

  def rails_admin_preview_path
    '/startups'
  end

  private

  def set_slug
    self.slug ||= (startup_name || id.to_s).parameterize if slug.blank?
  end
end
