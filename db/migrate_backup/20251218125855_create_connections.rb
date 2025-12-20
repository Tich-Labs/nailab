class CreateConnections < ActiveRecord::Migration[8.1]
  def change
    create_table :connections do |t|
      t.references :user, null: false, foreign_key: true
      t.references :peer, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
