class CreateStartups < ActiveRecord::Migration[8.1]
  def change
    create_table :startups do |t|
      t.string :name
      t.text :description
      t.string :website
      t.string :industry
      t.date :founded_on
      t.boolean :approved

      t.timestamps
    end
  end
end
