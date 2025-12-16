class CreateMentorshipRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :mentorship_requests do |t|
      t.references :founder, null: false, foreign_key: { to_table: :users }
      t.references :mentor, null: false, foreign_key: { to_table: :users }
      t.text :message
      t.string :status, default: 'pending', null: false
      t.datetime :responded_at

      t.timestamps
    end

    add_index :mentorship_requests, :status
  end
end
