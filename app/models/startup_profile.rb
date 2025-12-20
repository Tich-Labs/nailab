    # Returns the total team size: founder + team members
    def team_size
      1 + (team_members.is_a?(Array) ? team_members.size : 0)
    end
  # Returns the display value for sector, using other_sector if sector is 'Other'
  def sector_display
    sector == 'Other' ? other_sector.presence || 'Other' : sector
  end
class StartupProfile < ApplicationRecord
  belongs_to :user

  validates :startup_name, :description, :stage, :target_market, :value_proposition, presence: true
  validates :sector, :funding_stage, presence: true, if: -> { user&.user_profile&.onboarding_completed? }
  validates :website_url, :logo_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true, message: 'must be a valid URL' }

  # Set default value for team_members
  after_initialize :set_defaults, if: :new_record?

  def public_viewable?
    profile_visibility?
  end

  def rails_admin_preview_path
    '/startups'
  end

  def team_members
    value = super
    if value.is_a?(String)
      begin
        JSON.parse(value)
      rescue JSON::ParserError
        []
      end
    else
      value || []
    end
  end

  def add_team_member(name, role)
    current_members = team_members || []
    current_members << { 'name' => name, 'role' => role, 'id' => SecureRandom.uuid }
    update(team_members: current_members)
  end

  def remove_team_member(member_id)
    current_members = team_members || []
    updated_members = current_members.reject { |member| member['id'] == member_id }
    update(team_members: updated_members)
  end

  private

  def set_defaults
    self.team_members ||= []
  end
end
