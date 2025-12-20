class AddStartDateToPrograms < ActiveRecord::Migration[8.1]
  def change
    add_column :programs, :start_date, :date, if_not_exists: true
    add_index :programs, :start_date, if_not_exists: true
  end
end
