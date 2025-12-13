class CreateMentorshipSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :mentorship_sessions do |t|
      t.references :mentorship_request, null: false, foreign_key: true
      t.datetime :date
      t.integer :duration
      t.text :notes
      t.text :feedback
      t.integer :rating

      t.timestamps
    end
  end
end
