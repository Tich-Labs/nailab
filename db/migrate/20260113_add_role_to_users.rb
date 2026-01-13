class AddRoleToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :role, :string, null: false, default: "founder"
    add_index :users, :role
  end
end
