class CreateFounderApplications < ActiveRecord::Migration[6.1]
  def change
    create_table :founder_applications, if_not_exists: true do |t|
      t.string :name
      t.string :email
      t.string :startup_name
      t.string :industry
      t.text :mentorship_needs
      t.integer :team_size

      t.timestamps
    end
  end
end