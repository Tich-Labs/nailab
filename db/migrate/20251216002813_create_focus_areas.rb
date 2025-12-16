class CreateFocusAreas < ActiveRecord::Migration[8.1]
  def change
    create_table :focus_areas do |t|
      t.string :title, null: false
      t.text :description
      t.string :icon
      t.integer :display_order, default: 1, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :focus_areas, :display_order
    add_index :focus_areas, :active
  end
end
