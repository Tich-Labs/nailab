class CreateStartupProfiles < ActiveRecord::Migration[8.1]
  def change
    return if table_exists?(:startup_profiles)

    create_table :startup_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :startup_name, null: false
      t.string :sector
      t.string :stage
      t.string :location
      t.text :description
      t.jsonb :mentorship_areas
      t.string :website_url
      t.integer :founded_year
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :startup_profiles, :active
  end
end
