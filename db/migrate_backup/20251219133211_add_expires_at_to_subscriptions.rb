class AddExpiresAtToSubscriptions < ActiveRecord::Migration[8.1]
  def change
    add_column :subscriptions, :expires_at, :datetime
  end
end
