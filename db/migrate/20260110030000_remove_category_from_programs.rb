class RemoveCategoryFromPrograms < ActiveRecord::Migration[7.0]
  def up
    if column_exists?(:programs, :category)
      remove_column :programs, :category
    end
  end

  def down
    unless column_exists?(:programs, :category)
      add_column :programs, :category, :string
    end
  end
end
