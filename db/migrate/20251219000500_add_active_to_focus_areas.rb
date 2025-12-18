class AddActiveToFocusAreas < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    unless column_exists?(:focus_areas, :active)
      add_column :focus_areas, :active, :boolean, default: true, null: false
      add_index :focus_areas, :active
    end
  end
end
