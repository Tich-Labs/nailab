class CreateStartups < ActiveRecord::Migration[8.1]
  def change
    create_table :startups do |t|
      t.string :name, null: false
      t.string :sector
      t.string :stage
      t.string :location
      t.text :description
      t.string :website_url
      t.string :status
      t.text :mentor_focus
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :startups, :active
    add_index :startups, :sector
  end
end
