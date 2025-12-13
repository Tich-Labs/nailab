class AddDescriptionToTemplateGuides < ActiveRecord::Migration[8.1]
  def change
    add_column :template_guides, :description, :text
  end
end
