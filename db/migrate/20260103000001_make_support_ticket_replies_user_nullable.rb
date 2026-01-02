class MakeSupportTicketRepliesUserNullable < ActiveRecord::Migration[8.1]
  def change
    change_column_null :support_ticket_replies, :user_type, true
    change_column_null :support_ticket_replies, :user_id, true
  end
end
