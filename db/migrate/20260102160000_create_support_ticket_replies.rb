class CreateSupportTicketReplies < ActiveRecord::Migration[8.1]
  def change
    create_table :support_ticket_replies do |t|
      t.references :support_ticket, null: false, foreign_key: true
      t.references :user, polymorphic: true, null: false
      t.text :body, null: false
      t.timestamps
    end

    add_index :support_ticket_replies, :support_ticket_id unless index_exists?(:support_ticket_replies, :support_ticket_id)
    add_index :support_ticket_replies, :user_id unless index_exists?(:support_ticket_replies, :user_id)
    add_index :support_ticket_replies, :user_type unless index_exists?(:support_ticket_replies, :user_type)
  end
end