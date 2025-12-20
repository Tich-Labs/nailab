class CreateSupportTickets < ActiveRecord::Migration[8.1]
  def change
    create_table :support_tickets do |t|
      t.references :user, null: false, foreign_key: true
      t.string :subject, null: false
      t.string :category, null: false
      t.text :description, null: false
      t.string :status, null: false, default: 'open'
      t.text :admin_note

      t.timestamps
    end
  end
end
