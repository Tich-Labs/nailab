class AddMediaToPrograms < ActiveRecord::Migration[7.0]
  def change
    add_column :programs, :video_url, :string
    add_column :programs, :inline_image_urls, :text, array: true, default: []
  end
end
