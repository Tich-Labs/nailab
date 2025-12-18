class ChangeMilestonesForeignKey < ActiveRecord::Migration[8.1]
  def change
    remove_column :milestones, :startup_id
    add_reference :milestones, :user, null: false, foreign_key: true
  end
end
