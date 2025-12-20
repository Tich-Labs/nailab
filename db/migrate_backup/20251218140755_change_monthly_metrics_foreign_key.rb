class ChangeMonthlyMetricsForeignKey < ActiveRecord::Migration[8.1]
  def change
    remove_column :monthly_metrics, :startup_id
    add_reference :monthly_metrics, :user, null: false, foreign_key: true
  end
end
