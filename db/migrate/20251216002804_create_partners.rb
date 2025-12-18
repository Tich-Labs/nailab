class CreatePartners < ActiveRecord::Migration[8.1]
  def change
    return if table_exists?(:partners)

    create_table :partners do |t|
      t.string :name, null: false
      t.string :logo_url
      t.string :website_url
      t.integer :display_order, default: 1, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :partners, :display_order
    add_index :partners, :active
  end
end
