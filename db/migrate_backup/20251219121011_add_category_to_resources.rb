class AddCategoryToResources < ActiveRecord::Migration[8.1]
  def change
    add_column :resources, :category, :string
  end
end
