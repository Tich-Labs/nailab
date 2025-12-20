class CreateFocusAreas < ActiveRecord::Migration[8.1]
  include MigrationHelpers

  def change
    return if table_exists?(:focus_areas)

    create_table :focus_areas do |t|
      t.string :title, null: false
      t.text :description
      t.string :icon
      add_common_columns(t)
    end

    add_common_indexes(:focus_areas)
  end
end
