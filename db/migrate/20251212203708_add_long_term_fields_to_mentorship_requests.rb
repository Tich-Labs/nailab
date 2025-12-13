class AddLongTermFieldsToMentorshipRequests < ActiveRecord::Migration[8.1]
  def change
    add_column :mentorship_requests, :full_name, :string
    add_column :mentorship_requests, :phone_number, :string
    add_column :mentorship_requests, :target_market, :text
    add_column :mentorship_requests, :preferred_mentorship_mode, :string
    add_column :mentorship_requests, :funding_structure, :string
    add_column :mentorship_requests, :total_funding, :string
    add_column :mentorship_requests, :top_mentorship_areas, :string
  end
end
