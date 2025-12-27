class AddVideoUrlToPrograms < ActiveRecord::Migration[7.0]
  def change
    add_column :programs, :video_url, :string
  end
end
