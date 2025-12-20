class AddProfileVisibilityToStartupProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :startup_profiles, :profile_visibility, :boolean, default: false, null: false unless column_exists?(:startup_profiles, :profile_visibility)
  end
end
