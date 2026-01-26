class AddUserIdToMonthlyMetrics < ActiveRecord::Migration[8.1]
  def change
    add_column :monthly_metrics, :user_id, :bigint
    add_index :monthly_metrics, :user_id
  end
end
