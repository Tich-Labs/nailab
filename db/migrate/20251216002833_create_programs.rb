class CreatePrograms < ActiveRecord::Migration[8.1]
  def change
    create_table :programs do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :description
      t.string :cover_image_url
      t.string :category
      t.date :start_date
      t.date :end_date
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :programs, :slug, unique: true
    add_index :programs, :active
  end
end
