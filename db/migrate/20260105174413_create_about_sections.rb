class CreateAboutSections < ActiveRecord::Migration[8.1]
  def change
    create_table :about_sections do |t|
      t.string :title
      t.string :section_type
      t.text :content

      t.timestamps
    end
  end
end
