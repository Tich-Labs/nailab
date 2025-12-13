class CreateMentorApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :mentor_applications do |t|
      t.string :full_name
      t.string :email
      t.text :short_bio
      t.string :current_role
      t.integer :experience_years
      t.boolean :has_advisory_experience
      t.string :organization
      t.string :industries
      t.string :mentorship_topics
      t.integer :preferred_stages
      t.integer :availability_hours
      t.text :approach
      t.text :motivation
      t.integer :mode
      t.decimal :rate
      t.string :linkedin_url
      t.integer :status

      t.timestamps
    end
  end
end
