class CreateTestimonials < ActiveRecord::Migration[8.1]
  def change
    return if table_exists?(:testimonials)

    create_table :testimonials do |t|
      t.string :author_name, null: false
      t.string :author_role
      t.string :organization
      t.text :quote
      t.string :photo_url
      t.integer :display_order, default: 1, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    unless index_exists?(:testimonials, :display_order)
      add_index :testimonials, :display_order
    end
    unless index_exists?(:testimonials, :active)
      add_index :testimonials, :active
    end
  end
end
