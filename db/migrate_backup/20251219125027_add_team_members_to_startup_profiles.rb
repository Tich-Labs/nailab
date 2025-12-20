class AddTeamMembersToStartupProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :startup_profiles, :team_members, :jsonb
  end
end
