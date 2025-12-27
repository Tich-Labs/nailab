class CreateStartupProfiles < ActiveRecord::Migration[8.1]
  def change
    drop_table :startup_profiles, if_exists: true
    create_table :startup_profiles do |t|
      t.boolean :active, default: true, null: false
      t.text :challenge_details
      t.datetime :created_at, null: false
      t.text :description
      t.integer :founded_year
      t.decimal :funding_raised, precision: 14, scale: 2
      t.string :funding_stage
      t.string :location
      t.string :logo_url
      t.jsonb :mentorship_areas
      t.string :other_sector
      t.string :phone_number
      t.string :preferred_mentorship_mode
      t.boolean :profile_visibility, default: false, null: false
      t.string :sector
      t.string :stage
      t.string :startup_name, null: false
      t.text :target_market
      t.jsonb :team_members
      t.integer :team_size, default: 0
      t.datetime :updated_at, null: false
      t.bigint :user_id, null: false
      t.text :value_proposition
      t.string :website_url
      t.index ["active"], name: "index_startup_profiles_on_active"
      t.index ["user_id"], name: "index_startup_profiles_on_user_id"
    end
  end
end
