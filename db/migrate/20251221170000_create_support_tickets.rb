class CreateSupportTickets < ActiveRecord::Migration[8.1]
  def change
    create_table :support_tickets, if_not_exists: true do |t|
      t.references :user, null: false, foreign_key: true
      t.string :subject, null: false
      t.string :category, null: false
      t.text :description, null: false
      t.text :admin_note
      t.string :status, default: "open", null: false
      t.timestamps
    end
    add_index :support_tickets, :status, if_not_exists: true
  end
end
