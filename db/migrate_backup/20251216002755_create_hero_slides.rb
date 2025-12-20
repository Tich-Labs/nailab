class CreateHeroSlides < ActiveRecord::Migration[8.1]
  include MigrationHelpers

  def change
    return if table_exists?(:hero_slides)

    create_table :hero_slides do |t|
      t.string :title
      t.text :subtitle
      t.string :image_url
      t.string :cta_text
      t.string :cta_link
      add_common_columns(t)
    end

    add_common_indexes(:hero_slides)
  end
end
