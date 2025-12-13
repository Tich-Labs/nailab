class CreateOpportunities < ActiveRecord::Migration[8.1]
  def change
    create_table :opportunities do |t|
      t.string :title
      t.text :description
      t.string :url
      t.date :deadline

      t.timestamps
    end
  end
end
