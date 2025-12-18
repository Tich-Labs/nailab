class CreateMentorshipConnections < ActiveRecord::Migration[8.1]
  def change
    return if table_exists?(:mentorship_connections)

    create_table :mentorship_connections do |t|
      t.references :founder, null: false, foreign_key: { to_table: :users }
      t.references :mentor, null: false, foreign_key: { to_table: :users }
      t.references :mentorship_request, null: false, foreign_key: true
      t.string :status, default: 'active', null: false

      t.timestamps
    end

    add_index :mentorship_connections, :status
  end
end
