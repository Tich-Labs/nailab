class AddRoleToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :role, :string, default: "founder", null: false unless column_exists?(:users, :role)
    add_index :users, :role, if_not_exists: true
  end
end