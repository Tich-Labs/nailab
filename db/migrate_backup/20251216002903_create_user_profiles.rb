class CreateUserProfiles < ActiveRecord::Migration[8.1]
  def change
    return if table_exists?(:user_profiles)

    create_table :user_profiles do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :role
      t.string :full_name
      t.text :bio
      t.string :location
      t.string :photo_url
      t.string :title
      t.string :organization
      t.string :linkedin_url
      t.integer :years_experience
      t.boolean :advisory_experience, default: false, null: false
      t.jsonb :sectors
      t.jsonb :expertise
      t.jsonb :stage_preference
      t.integer :availability_hours_month, default: 0, null: false
      t.decimal :rate_per_hour, precision: 10, scale: 2
      t.boolean :pro_bono, default: false, null: false
      t.string :preferred_mentorship_mode
      t.boolean :profile_visibility, default: true, null: false
      t.boolean :onboarding_completed, default: false, null: false

      t.timestamps
    end
  end
end
