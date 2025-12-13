class CreateHomepageSections < ActiveRecord::Migration[8.1]
  def change
    create_table :homepage_sections do |t|
      t.string :title
      t.string :subtitle
      t.integer :section_type
      t.text :content
      t.string :cta_text
      t.string :cta_url
      t.integer :position
      t.boolean :visible

      t.timestamps
    end
  end
end
