class AddContentToPrograms < ActiveRecord::Migration[8.1]
  def change
    add_column :programs, :content, :text
  end
end
