class CreateUserProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :user_profiles, if_not_exists: true do |t|
      t.references :user, null: false, foreign_key: true
      t.string :role
      t.boolean :onboarding_completed, default: false, null: false
      t.boolean :profile_visibility, default: true, null: false
      t.string :full_name
      t.text :bio
      t.string :title
      t.string :organization
      t.integer :years_experience
      t.integer :advisory_experience
      t.text :advisory_description
      t.string :sectors, array: true, default: []
      t.string :expertise, array: true, default: []
      t.string :stage_preference, array: true, default: []
      t.text :mentorship_approach
      t.text :motivation
      t.integer :availability_hours_month
      t.string :preferred_mentorship_mode
      t.integer :rate_per_hour
      t.boolean :pro_bono, default: false, null: false
      t.string :linkedin_url
      t.string :professional_website
      t.string :currency
      t.timestamps
    end
    add_index :user_profiles, :user_id, if_not_exists: true
    add_index :user_profiles, :role, if_not_exists: true
    add_index :user_profiles, :profile_visibility, if_not_exists: true
  end
end
