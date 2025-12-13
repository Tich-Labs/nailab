class AddProfileFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :name, :string
    add_column :users, :bio, :text
    add_column :users, :avatar, :string
    add_column :users, :sector, :string
    add_column :users, :expertise, :string
    add_column :users, :location, :string
    add_column :users, :role, :string
  end
end
