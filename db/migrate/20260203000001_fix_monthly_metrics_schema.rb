class FixMonthlyMetricsSchema < ActiveRecord::Migration[8.1]
  def change
    # Check if table exists and needs fixing
    if table_exists?(:monthly_metrics)
      # Add missing columns if they don't exist
      add_column :monthly_metrics, :period, :date unless column_exists?(:monthly_metrics, :period)
      add_column :monthly_metrics, :runway, :integer unless column_exists?(:monthly_metrics, :runway)
      add_column :monthly_metrics, :funding_stage, :string unless column_exists?(:monthly_metrics, :funding_stage)
      add_column :monthly_metrics, :funds_raised, :decimal, precision: 10, scale: 2 unless column_exists?(:monthly_metrics, :funds_raised)
      add_column :monthly_metrics, :investors_engaged, :string unless column_exists?(:monthly_metrics, :investors_engaged)
      add_column :monthly_metrics, :product_progress, :text unless column_exists?(:monthly_metrics, :product_progress)
      add_column :monthly_metrics, :mrr, :decimal unless column_exists?(:monthly_metrics, :mrr)

      # Restore startup_id if it was removed
      unless column_exists?(:monthly_metrics, :startup_id)
        add_column :monthly_metrics, :startup_id, :bigint
        add_foreign_key :monthly_metrics, :startups unless foreign_key_exists?(:monthly_metrics, :startups)
      end

      # Migrate data from month to period if month exists but period doesn't have data
      if column_exists?(:monthly_metrics, :month) && column_exists?(:monthly_metrics, :period)
        execute("UPDATE monthly_metrics SET period = month WHERE period IS NULL AND month IS NOT NULL")
      end

      # Remove the old month column if it exists (since we now use period)
      remove_column :monthly_metrics, :month, :date if column_exists?(:monthly_metrics, :month)

      # Remove old revenue column if it exists
      remove_column :monthly_metrics, :revenue, :decimal if column_exists?(:monthly_metrics, :revenue)
    end
  end
end
