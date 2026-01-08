class AddHeroAndInlineImagesToResources < ActiveRecord::Migration[7.0]
  def change
    # For ActiveStorage attachments
    add_column :resources, :hero_image_url, :string
    add_column :resources, :inline_image_urls, :text, array: true, default: []
  end
end
