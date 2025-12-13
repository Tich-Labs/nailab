class AddAvailableToMentors < ActiveRecord::Migration[8.1]
  def change
    add_column :mentors, :available, :boolean
  end
end
