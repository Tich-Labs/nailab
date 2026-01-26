class CreateStartupInvites < ActiveRecord::Migration[7.0]
  def change
    create_table :startup_invites do |t|
      t.references :startup, null: false, foreign_key: true
      t.references :inviter, null: false, foreign_key: { to_table: :users }
      t.string :invitee_name
      t.string :invitee_email, null: false
      t.string :role
      t.string :token, null: false
      t.datetime :sent_at
      t.datetime :accepted_at

      t.timestamps
    end

    add_index :startup_invites, :token, unique: true
    add_index :startup_invites, :invitee_email
  end
end
