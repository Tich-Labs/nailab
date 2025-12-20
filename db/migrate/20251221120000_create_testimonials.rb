class CreateTestimonials < ActiveRecord::Migration[8.1]
  def change
    create_table :testimonials, if_not_exists: true do |t|
      t.string :author_name, null: false
      t.string :author_role
      t.string :organization
      t.text :quote
      t.integer :display_order, default: 1, null: false
      t.boolean :active, default: true, null: false
      t.timestamps
    end
    add_index :testimonials, :display_order, if_not_exists: true
    add_index :testimonials, :active, if_not_exists: true
  end
end
