class AddActiveToFocusAreas < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    unless column_exists?(:focus_areas, :active)
      add_column :focus_areas, :active, :boolean, default: true, null: false
    end

    unless index_exists?(:focus_areas, :active)
      add_index :focus_areas, :active
    end
  end
end
