class AddDetailsToMentors < ActiveRecord::Migration[8.1]
  def change
    add_column :mentors, :years_experience, :integer
    add_column :mentors, :current_affiliation, :string
    add_column :mentors, :advisor_or_investor, :boolean
    add_column :mentors, :mentorship_industries, :string
    add_column :mentors, :mentorship_areas, :string
    add_column :mentors, :preferred_stage, :string
    add_column :mentors, :availability_hours_per_month, :integer
    add_column :mentors, :mentorship_approach, :text
    add_column :mentors, :motivation, :text
    add_column :mentors, :mentorship_mode, :string
    add_column :mentors, :hourly_rate, :decimal
    add_column :mentors, :linkedin_url, :string
    add_column :mentors, :website_url, :string
  end
end
