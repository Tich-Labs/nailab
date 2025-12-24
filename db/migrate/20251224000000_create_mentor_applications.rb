class CreateMentorApplications < ActiveRecord::Migration[6.1]
  def change
    create_table :mentor_applications, if_not_exists: true do |t|
      t.string :name
      t.string :email
      t.text :work_experience
      t.text :mentorship_focus
      t.text :mentorship_style
      t.string :availability

      t.timestamps
    end
  end
end