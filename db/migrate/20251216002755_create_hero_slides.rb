class CreateHeroSlides < ActiveRecord::Migration[8.1]
  def change
    return if table_exists?(:hero_slides)

    create_table :hero_slides do |t|
      t.string :title
      t.text :subtitle
      t.string :image_url
      t.string :cta_text
      t.string :cta_link
      t.integer :display_order, default: 1, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :hero_slides, :display_order
  end
end
