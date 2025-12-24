class AddAreasNeededAndPreferredModeToMentorshipRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :mentorship_requests, :areas_needed, :string, array: true, default: [], if_not_exists: true
    add_column :mentorship_requests, :preferred_mode, :string, if_not_exists: true
  end
end
