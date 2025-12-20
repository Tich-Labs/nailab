class EnsureUserIdOnStartupProfiles < ActiveRecord::Migration[7.0]
  def change
    unless column_exists?(:startup_profiles, :user_id)
      add_reference :startup_profiles, :user, null: false, foreign_key: true
    end
  end
end
