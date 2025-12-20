class AddUserIdToStartupProfiles < ActiveRecord::Migration[7.0]
  def change
     # Migration disabled: user_id column already exists in startup_profiles
     # add_reference :startup_profiles, :user, null: false, foreign_key: true
  end
end
