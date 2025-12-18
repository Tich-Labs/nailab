class CreateConversations < ActiveRecord::Migration[8.1]
  def change
    return if table_exists?(:conversations)

    create_table :conversations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :mentor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
