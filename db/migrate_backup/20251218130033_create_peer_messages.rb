class CreatePeerMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :peer_messages do |t|
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      t.text :content

      t.timestamps
    end
  end
end
