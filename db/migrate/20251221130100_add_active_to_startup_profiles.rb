class AddActiveToStartupProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :startup_profiles, :active, :boolean, default: true, null: false, if_not_exists: true
    add_index :startup_profiles, :active, if_not_exists: true
  end
end
