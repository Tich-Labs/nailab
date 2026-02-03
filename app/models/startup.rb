class Startup < ApplicationRecord
  belongs_to :user
  has_many :team_members, dependent: :destroy
  has_many :team_users, through: :team_members, source: :user
  has_many :startup_updates, dependent: :destroy
  has_many :monthly_metrics, dependent: :destroy
  has_many :startup_invites, dependent: :destroy

  validates :name, presence: true
  validates :user_id, presence: true

  before_create :auto_add_founder_as_owner
  after_create :mark_team_initialized

  # Helper scopes
  scope :active, -> { where(active: true) }
  scope :by_sector, ->(sector) { where(sector: sector) if sector.present? }
  scope :by_stage, ->(stage) { where(stage: stage) if stage.present? }

  # Team management helpers
  def owner
    team_members.owners.first&.user
  end

  def has_team_member?(user)
    team_users.exists?(user)
  end

  def add_team_member(user, role: :member)
    team_members.create!(user: user, role: role)
  end

  def remove_team_member(user)
    team_members.find_by(user: user)&.destroy
  end

  def team_size_current
    team_members.count
  end

  # Returns the team size, treating the founder as a team of 1 when no
  # explicit TeamMember rows exist for the startup.
  def team_size
    cnt = team_members.count
    return cnt if cnt.positive?
    user.present? ? 1 : 0
  end

  private

  def auto_add_founder_as_owner
    # Founder will be added in after_create callback
  end

  def mark_team_initialized
    # Create the founder as the owner team member
    TeamMember.create!(
      startup: self,
      user: user,
      role: :owner,
      is_founder: true
    )
    update_column(:team_initialized, true)
  end
end
