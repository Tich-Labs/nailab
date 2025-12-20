class AddMissingFieldsToMentorshipRequests < ActiveRecord::Migration[8.1]
  def change
    change_table :mentorship_requests, bulk: true do |t|
      t.string :mentorship_mode
      t.text :details
    end
  end
end
