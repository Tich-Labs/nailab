class CreateCategoriesProgramsJoin < ActiveRecord::Migration[7.0]
  def change
    create_table :categories_programs, id: false do |t|
      t.bigint :category_id, null: false
      t.bigint :program_id, null: false
    end
    add_index :categories_programs, [ :category_id, :program_id ], unique: true
    add_index :categories_programs, :program_id
  end
end
