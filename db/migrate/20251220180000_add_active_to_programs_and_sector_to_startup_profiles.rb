class AddActiveToProgramsAndSectorToStartupProfiles < ActiveRecord::Migration[8.1]
  def change
    # Add 'active' column to programs unless it already exists
    unless column_exists?(:programs, :active)
      add_column :programs, :active, :boolean, default: true, null: false
      add_index :programs, :active
    end

    # Add 'sector' column to startup_profiles unless it already exists
    unless column_exists?(:startup_profiles, :sector)
      add_column :startup_profiles, :sector, :string
    end
  end
end
