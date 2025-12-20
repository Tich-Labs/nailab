class CreateSupportTickets < ActiveRecord::Migration[8.1]
  def change
    create_table :support_tickets do |t|
      t.references :user, null: false, foreign_key: true
      t.string :subject, null: false
      t.text :message, null: false
      t.string :status, default: "open", null: false
      t.timestamps
    end
    add_index :support_tickets, :status
  end
end
