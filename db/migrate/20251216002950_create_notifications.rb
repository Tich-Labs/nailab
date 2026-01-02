class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    return if table_exists?(:notifications)

    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :notif_type
      t.string :title
      t.text :message
      t.string :link
      t.boolean :read, default: false, null: false
      t.jsonb :metadata

      t.timestamps
    end

    add_index :notifications, [ :user_id, :read ]
    add_index :notifications, :notif_type
  end
end
