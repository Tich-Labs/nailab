class AddEnumRoleToUsers < ActiveRecord::Migration[8.1]
  def change
    # Add new integer role column
    add_column :users, :role_enum, :integer, default: 0, null: false

    # Convert existing string roles to enum values
    User.update_all(
      "role_enum = CASE role
                   WHEN 'founder' THEN 0
                   WHEN 'mentor' THEN 1
                   WHEN 'partner' THEN 2
                   ELSE 0 END"
    )

    # Remove old string role column
    remove_column :users, :role

    # Rename new column to role
    rename_column :users, :role_enum, :role
  end
end
