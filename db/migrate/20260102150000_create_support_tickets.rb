class CreateSupportTickets < ActiveRecord::Migration[8.1]
  def change
    create_table :support_tickets do |t|
      t.references :user, null: false, foreign_key: true
      t.string :portal
      t.string :subject, null: false
      t.string :category
      t.text :description, null: false
      t.string :status, null: false, default: "open"

      t.timestamps
    end

    add_index :support_tickets, :portal
    add_index :support_tickets, :status
  end
end
