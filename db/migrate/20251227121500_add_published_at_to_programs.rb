class AddPublishedAtToPrograms < ActiveRecord::Migration[7.0]
  def change
    add_column :programs, :published_at, :datetime
  end
end
