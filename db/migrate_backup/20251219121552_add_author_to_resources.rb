class AddAuthorToResources < ActiveRecord::Migration[8.1]
  def change
    add_column :resources, :author, :string
  end
end
