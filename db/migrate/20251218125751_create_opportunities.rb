class CreateOpportunities < ActiveRecord::Migration[8.1]
  def change
    create_table :opportunities do |t|
      t.string :title
      t.string :organizer
      t.text :description
      t.date :deadline
      t.string :application_url
      t.string :category

      t.timestamps
    end
  end
end
