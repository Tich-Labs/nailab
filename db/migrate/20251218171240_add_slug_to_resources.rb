class AddSlugToResources < ActiveRecord::Migration[8.1]
  def change
    add_column :resources, :slug, :string
  end
end
