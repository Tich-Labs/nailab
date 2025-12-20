class AddCoverImageUrlToPrograms < ActiveRecord::Migration[8.1]
  def change
    add_column :programs, :cover_image_url, :string, if_not_exists: true
  end
end
