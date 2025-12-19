class CreateFocusAreas < ActiveRecord::Migration[8.1]
  def change
    return if table_exists?(:focus_areas)

    create_table :focus_areas do |t|
      t.string :title, null: false
      t.text :description
      t.string :icon
      t.integer :display_order, default: 1, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    unless index_exists?(:focus_areas, :display_order)
      add_index :focus_areas, :display_order
    end
    unless index_exists?(:focus_areas, :active)
      add_index :focus_areas, :active
    end
  end
end
