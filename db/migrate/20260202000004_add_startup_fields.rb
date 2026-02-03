class AddStartupFields < ActiveRecord::Migration[7.0]
  def change
    # Add columns only if they don't already exist
    unless column_exists?(:startups, :team_size)
      add_column :startups, :team_size, :integer, default: 1
    end

    unless column_exists?(:startup_profiles, :logo_file_size)
      add_column :startup_profiles, :logo_file_size, :integer
    end

    unless column_exists?(:startup_profiles, :logo_content_type)
      add_column :startup_profiles, :logo_content_type, :string
    end

    unless column_exists?(:startups, :team_initialized)
      add_column :startups, :team_initialized, :boolean, default: false
    end

    # Add indexes only if they don't exist
    unless index_exists?(:startups, :team_size)
      add_index :startups, :team_size
    end

    unless index_exists?(:startups, :team_initialized)
      add_index :startups, :team_initialized
    end
  end
end
