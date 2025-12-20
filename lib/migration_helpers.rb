module MigrationHelpers
  def add_common_columns(t)
    t.integer :display_order, default: 1, null: false
    t.boolean :active, default: true, null: false
    t.timestamps
  end

  def add_common_indexes(table_name)
    add_index table_name, :display_order unless index_exists?(table_name, :display_order)
    add_index table_name, :active unless index_exists?(table_name, :active)
  end
end
