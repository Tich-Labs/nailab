class AddDisplayOrderToFocusAreas < ActiveRecord::Migration[8.1]
  def change
    unless column_exists?(:focus_areas, :display_order)
      add_column :focus_areas, :display_order, :integer, default: 0, null: false
    end

    unless index_exists?(:focus_areas, :display_order)
      add_index :focus_areas, :display_order
    end
  end
end
