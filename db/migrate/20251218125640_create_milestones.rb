class CreateMilestones < ActiveRecord::Migration[8.1]
  def change
    return if table_exists?(:milestones)

    create_table :milestones do |t|
      t.string :title
      t.text :description
      t.date :due_date
      t.boolean :completed
      t.references :startup, null: false, foreign_key: true

      t.timestamps
    end
  end
end
