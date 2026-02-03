class AddIndexToMonthlyMetricsPeriod < ActiveRecord::Migration[8.1]
  def change
    # Add index on period column for faster ordering and filtering
    add_index :monthly_metrics, :period, name: "index_monthly_metrics_on_period" unless index_exists?(:monthly_metrics, :period)
  end
end
