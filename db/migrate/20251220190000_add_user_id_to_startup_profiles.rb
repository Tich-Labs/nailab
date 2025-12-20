class AddUserIdToStartupProfiles < ActiveRecord::Migration[7.0]
  def change
    add_reference :startup_profiles, :user, null: false, foreign_key: true
  end
end
