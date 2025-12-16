class CreateResources < ActiveRecord::Migration[8.1]
  def change
    create_table :resources do |t|
      t.string :title, null: false
      t.text :description
      t.string :url
      t.string :resource_type
      t.datetime :published_at
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :resources, :active
    add_index :resources, :published_at
  end
end
