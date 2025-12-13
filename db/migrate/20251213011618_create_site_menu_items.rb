class CreateSiteMenuItems < ActiveRecord::Migration[8.1]
  def change
    create_table :site_menu_items do |t|
      t.string :title
      t.string :path
      t.boolean :visible
      t.integer :position
      t.integer :location

      t.timestamps
    end
  end
end
