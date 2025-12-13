class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.date :date
      t.string :location
      t.string :registration_url

      t.timestamps
    end
  end
end
