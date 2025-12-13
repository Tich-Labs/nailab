class CreateMentorshipRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :mentorship_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :mentor, foreign_key: true
      t.string :request_type, null: false
      t.string :status, default: "pending", null: false
      t.string :topic
      t.date :date
      t.text :goal
      t.string :startup_name
      t.text :startup_bio
      t.string :startup_stage
      t.string :startup_industry
      t.string :startup_funding
      t.text :mentorship_needs

      t.timestamps
    end
  end
end
