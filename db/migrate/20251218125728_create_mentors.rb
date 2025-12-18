class CreateMentors < ActiveRecord::Migration[8.1]
  def change
    create_table :mentors do |t|
      t.string :name
      t.string :title
      t.string :photo
      t.string :expertise
      t.text :bio
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
