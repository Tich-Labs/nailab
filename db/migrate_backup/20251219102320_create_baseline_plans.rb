class CreateBaselinePlans < ActiveRecord::Migration[8.1]
  def change
    create_table :baseline_plans do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.decimal :baseline_revenue
      t.integer :baseline_customers
      t.decimal :baseline_burn_rate
      t.text :target_milestones

      t.timestamps
    end
  end
end
