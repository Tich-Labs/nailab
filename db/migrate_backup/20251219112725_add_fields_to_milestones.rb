class AddFieldsToMilestones < ActiveRecord::Migration[8.1]
  def change
    add_column :milestones, :category, :string
    add_column :milestones, :priority, :string
    add_column :milestones, :notes, :text
  end
end
