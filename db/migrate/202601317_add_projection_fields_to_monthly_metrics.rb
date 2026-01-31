class AddProjectionFieldsToMonthlyMetrics < ActiveRecord::Migration[7.0]
  def change
    add_column :monthly_metrics, :is_projection, :boolean, default: false, null: false
    add_column :monthly_metrics, :projection_index, :integer
    # Create a projection index. Some deployments have `startup_id` on this table,
    # others reference `user_id` instead (refactored foreign key). Add the index
    # on whichever FK column exists to keep this migration idempotent across
    # schema states.
    if column_exists?(:monthly_metrics, :startup_id)
      add_index :monthly_metrics, [ :startup_id, :is_projection, :projection_index ], name: "index_monthly_metrics_on_projection"
    elsif column_exists?(:monthly_metrics, :user_id)
      add_index :monthly_metrics, [ :user_id, :is_projection, :projection_index ], name: "index_monthly_metrics_on_projection"
    end
  end
end
