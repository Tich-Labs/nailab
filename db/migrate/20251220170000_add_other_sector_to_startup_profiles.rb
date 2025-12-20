class AddOtherSectorToStartupProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :startup_profiles, :other_sector, :string
  end
end
