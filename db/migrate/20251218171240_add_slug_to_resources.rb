class AddSlugToResources < ActiveRecord::Migration[8.1]
  def change
    unless column_exists?(:resources, :slug)
      add_column :resources, :slug, :string
    end
  end
end
