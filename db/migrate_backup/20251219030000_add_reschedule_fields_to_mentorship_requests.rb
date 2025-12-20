class AddRescheduleFieldsToMentorshipRequests < ActiveRecord::Migration[7.1]
  def change
    change_table :mentorship_requests, bulk: true do |t|
      t.text :decline_reason
      t.datetime :reschedule_requested_at
      t.text :reschedule_reason
      t.datetime :proposed_time
    end

    add_index :mentorship_requests, :proposed_time
  end
end
