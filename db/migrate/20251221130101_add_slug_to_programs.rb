class AddSlugToPrograms < ActiveRecord::Migration[8.1]
  def change
    add_column :programs, :slug, :string, if_not_exists: true
    add_index :programs, :slug, unique: true, if_not_exists: true
  end
end
