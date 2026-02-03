class AddMissingColumnsToMonthlyMetrics < ActiveRecord::Migration[8.1]
  def change
    unless column_exists?(:monthly_metrics, :new_paying_customers)
      add_column :monthly_metrics, :new_paying_customers, :integer
    end

    unless column_exists?(:monthly_metrics, :churned_customers)
      add_column :monthly_metrics, :churned_customers, :integer
    end

    unless column_exists?(:monthly_metrics, :customers)
      add_column :monthly_metrics, :customers, :integer
    end
  end
end
