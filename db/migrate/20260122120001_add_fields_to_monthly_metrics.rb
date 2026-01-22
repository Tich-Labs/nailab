class AddFieldsToMonthlyMetrics < ActiveRecord::Migration[8.1]
  def change
    rename_column :monthly_metrics, :month, :period
    rename_column :monthly_metrics, :revenue, :mrr
    remove_column :monthly_metrics, :runway, :integer

    add_column :monthly_metrics, :new_paying_customers, :integer
    add_column :monthly_metrics, :churned_customers, :integer
    add_column :monthly_metrics, :cash_at_hand, :decimal, precision: 10, scale: 2
    add_column :monthly_metrics, :product_progress, :text
    add_column :monthly_metrics, :funding_stage, :string
    add_column :monthly_metrics, :funds_raised, :decimal, precision: 10, scale: 2
    add_column :monthly_metrics, :investors_engaged, :string
  end
end
