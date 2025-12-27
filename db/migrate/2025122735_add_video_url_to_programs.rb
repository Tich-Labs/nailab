class AddVideoUrlToPrograms < ActiveRecord::Migration[7.0]
  def change
    unless column_exists?(:programs, :video_url)
      add_column :programs, :video_url, :string
    end
  end
end
