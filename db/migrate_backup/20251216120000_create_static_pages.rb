class CreateStaticPages < ActiveRecord::Migration[7.1]
  def change
    return if table_exists?(:static_pages)

    create_table :static_pages do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :content
      t.timestamps
    end
    add_index :static_pages, :slug, unique: true
  end
end
