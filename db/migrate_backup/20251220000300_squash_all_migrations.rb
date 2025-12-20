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

    # Add other tables and indexes here based on the current schema.
  end
end
