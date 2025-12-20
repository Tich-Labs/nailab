class AddMissingFieldsToMonthlyMetrics < ActiveRecord::Migration[8.1]
  def change
    add_column :monthly_metrics, :growth_rate, :decimal
    add_column :monthly_metrics, :churn_rate, :decimal
    add_column :monthly_metrics, :notes, :text
  end
end
