class CreateTestimonials < ActiveRecord::Migration[8.1]
  def change
    create_table :testimonials do |t|
      t.string :name
      t.text :quote
      t.boolean :visible
      t.integer :position

      t.timestamps
    end
  end
end
