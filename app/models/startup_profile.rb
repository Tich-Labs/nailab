class StartupProfile < ApplicationRecord
  belongs_to :user

  validates :startup_name, :description, :stage, :sector, :target_market, :value_proposition, presence: true
  validates :funding_stage, presence: true
  validates :website_url, :logo_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true, message: 'must be a valid URL' }

  def public_viewable?
    profile_visibility?
  end

  def rails_admin_preview_path
    '/startups'
  end
end
