class AddPublishedAtToPrograms < ActiveRecord::Migration[7.0]
  def change
    unless column_exists?(:programs, :published_at)
      add_column :programs, :published_at, :datetime
    end
  end
end
