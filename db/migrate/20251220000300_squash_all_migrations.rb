class SquashAllMigrations < ActiveRecord::Migration[8.1]
  def change
    # This migration represents the current state of the database schema.
    # It is a squashed version of all previous migrations.

    create_table :users, if_not_exists: true do |t|
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.timestamps null: false
    end
    add_index :users, :email, unique: true, if_not_exists: true
    add_index :users, :reset_password_token, unique: true, if_not_exists: true

    create_table :jwt_denylists, if_not_exists: true do |t|
      t.string :jti, null: false
      t.datetime :exp, null: false
    end
    add_index :jwt_denylists, :jti, if_not_exists: true

    create_table :hero_slides, if_not_exists: true do |t|
      t.string :title
      t.text :subtitle
      t.string :image_url
      t.string :cta_text
      t.string :cta_link
      t.integer :display_order, default: 1, null: false
      t.boolean :active, default: true, null: false
      t.timestamps
    end
    add_index :hero_slides, :display_order, if_not_exists: true

    create_table :partners, if_not_exists: true do |t|
      t.string :name, null: false
      t.string :logo_url
      t.string :website_url
      t.integer :display_order, default: 1, null: false
      t.boolean :active, default: true, null: false
      t.timestamps
    end
    add_index :partners, :display_order, if_not_exists: true
    add_index :partners, :active, if_not_exists: true

    create_table :focus_areas, if_not_exists: true do |t|
      t.string :title, null: false
      t.text :description
      t.string :icon
      t.integer :display_order, default: 1, null: false
      t.boolean :active, default: true, null: false
      t.timestamps
    end
    add_index :focus_areas, :display_order, if_not_exists: true
    add_index :focus_areas, :active, if_not_exists: true

    create_table :startup_profiles, if_not_exists: true do |t|
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

    # Add other tables and indexes here based on the current schema.
  end
end
