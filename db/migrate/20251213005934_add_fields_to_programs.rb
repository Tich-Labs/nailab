class AddFieldsToPrograms < ActiveRecord::Migration[8.1]
  def change
    add_column :programs, :title, :string
    add_column :programs, :summary, :text
    add_column :programs, :body, :text
    add_column :programs, :category, :integer
    add_column :programs, :apply_link, :string
    add_column :programs, :visible, :boolean
    add_column :programs, :position, :integer
  end
end
