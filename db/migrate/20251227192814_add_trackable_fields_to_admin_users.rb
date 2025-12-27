class AddTrackableFieldsToAdminUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :admin_users, :sign_in_count, :integer, default: 0, null: false, if_not_exists: true
    add_column :admin_users, :current_sign_in_at, :datetime, if_not_exists: true
    add_column :admin_users, :last_sign_in_at, :datetime, if_not_exists: true
    add_column :admin_users, :current_sign_in_ip, :string, if_not_exists: true
    add_column :admin_users, :last_sign_in_ip, :string, if_not_exists: true
  end
end
