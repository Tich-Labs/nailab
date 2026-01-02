class AddSlugToAdminModels < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :slug, :string
    add_index :users, :slug, unique: true
    add_column :mentors, :slug, :string
    add_index :mentors, :slug, unique: true
    add_column :user_profiles, :slug, :string
    add_index :user_profiles, :slug, unique: true
    add_column :startup_profiles, :slug, :string
    add_index :startup_profiles, :slug, unique: true
    add_column :programs, :slug, :string unless column_exists?(:programs, :slug)
    add_index :programs, :slug, unique: true unless index_exists?(:programs, :slug)
    add_column :resources, :slug, :string unless column_exists?(:resources, :slug)
    add_index :resources, :slug, unique: true unless index_exists?(:resources, :slug)
    # Add slug to other admin models as needed
  end
end
