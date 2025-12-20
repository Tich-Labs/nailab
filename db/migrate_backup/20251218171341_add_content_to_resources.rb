class AddContentToResources < ActiveRecord::Migration[8.1]
  def change
    add_column :resources, :content, :text
  end
end
