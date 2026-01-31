class AddProjectionFieldsToMonthlyMetrics < ActiveRecord::Migration[7.0]
  def change
    add_column :monthly_metrics, :is_projection, :boolean, default: false, null: false
    add_column :monthly_metrics, :projection_index, :integer
    add_index :monthly_metrics, [ :startup_id, :is_projection, :projection_index ], name: "index_monthly_metrics_on_projection"
  end
end
