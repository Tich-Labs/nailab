class AddConfirmableToUsers < ActiveRecord::Migration[7.1]
  def up
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string
    unless index_exists?(:users, :confirmation_token)
      add_index :users, :confirmation_token, unique: true
    end

    say_with_time "Marking existing users as confirmed" do
      User.reset_column_information
      User.where(confirmed_at: nil).update_all(
        confirmed_at: Time.current,
        confirmation_sent_at: Time.current
      )
    end
  end

  def down
    remove_index :users, :confirmation_token
    remove_column :users, :unconfirmed_email
    remove_column :users, :confirmation_sent_at
    remove_column :users, :confirmed_at
    remove_column :users, :confirmation_token
  end
end
