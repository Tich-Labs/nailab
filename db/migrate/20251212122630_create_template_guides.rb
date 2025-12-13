class CreateTemplateGuides < ActiveRecord::Migration[8.1]
  def change
    create_table :template_guides do |t|
      t.string :title
      t.string :category

      t.timestamps
    end
  end
end
