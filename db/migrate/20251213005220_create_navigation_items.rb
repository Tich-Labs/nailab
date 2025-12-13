class CreateNavigationItems < ActiveRecord::Migration[8.1]
  def change
    create_table :navigation_items do |t|
      t.string :title
      t.string :path
      t.integer :location
      t.boolean :visible
      t.integer :position

      t.timestamps
    end
  end
end
