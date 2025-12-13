class CreateMentors < ActiveRecord::Migration[8.1]
  def change
    create_table :mentors do |t|
      t.string :name
      t.text :bio
      t.string :expertise
      t.string :email
      t.boolean :approved

      t.timestamps
    end
  end
end
