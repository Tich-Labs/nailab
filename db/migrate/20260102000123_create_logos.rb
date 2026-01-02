class CreateLogos < ActiveRecord::Migration[7.0]
  def change
    create_table :logos do |t|
      t.string :name
      t.integer :display_order, default: 0, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
