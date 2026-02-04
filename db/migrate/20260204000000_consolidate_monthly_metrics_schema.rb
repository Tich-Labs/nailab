class ConsolidateMonthlyMetricsSchema < ActiveRecord::Migration[8.1]
  def change
    if table_exists?(:monthly_metrics)
      # === Add all potentially missing modern columns (idempotent) ===
      add_column :monthly_metrics, :period, :date unless column_exists?(:monthly_metrics, :period)
      add_column :monthly_metrics, :mrr, :decimal, precision: 15, scale: 2 unless column_exists?(:monthly_metrics, :mrr)
      add_column :monthly_metrics, :new_paying_customers, :integer unless column_exists?(:monthly_metrics, :new_paying_customers)
      add_column :monthly_metrics, :churned_customers, :integer unless column_exists?(:monthly_metrics, :churned_customers)
      add_column :monthly_metrics, :customers, :integer unless column_exists?(:monthly_metrics, :customers)
      add_column :monthly_metrics, :cash_at_hand, :decimal, precision: 15, scale: 2 unless column_exists?(:monthly_metrics, :cash_at_hand)
      add_column :monthly_metrics, :burn_rate, :decimal, precision: 15, scale: 2 unless column_exists?(:monthly_metrics, :burn_rate)
      add_column :monthly_metrics, :runway, :integer unless column_exists?(:monthly_metrics, :runway)
      add_column :monthly_metrics, :product_progress, :text unless column_exists?(:monthly_metrics, :product_progress)
      add_column :monthly_metrics, :funding_stage, :string unless column_exists?(:monthly_metrics, :funding_stage)
      add_column :monthly_metrics, :funds_raised, :decimal, precision: 15, scale: 2 unless column_exists?(:monthly_metrics, :funds_raised)
      add_column :monthly_metrics, :investors_engaged, :string unless column_exists?(:monthly_metrics, :investors_engaged)
      add_column :monthly_metrics, :is_projection, :boolean, default: false, null: false unless column_exists?(:monthly_metrics, :is_projection)
      add_column :monthly_metrics, :projection_index, :integer unless column_exists?(:monthly_metrics, :projection_index)

      # Restore startup_id foreign key if missing (common in older schemas)
      unless column_exists?(:monthly_metrics, :startup_id)
        add_column :monthly_metrics, :startup_id, :bigint
        add_index :monthly_metrics, :startup_id unless index_exists?(:monthly_metrics, :startup_id)
        add_foreign_key :monthly_metrics, :startups unless foreign_key_exists?(:monthly_metrics, :startups)
      end

      # === Data migration from legacy columns (only if needed) ===
      if column_exists?(:monthly_metrics, :month) && column_exists?(:monthly_metrics, :period)
        # Migrate any legacy 'month' data to the new 'period' column
        execute <<-SQL.squish
          UPDATE monthly_metrics
          SET period = month
          WHERE period IS NULL AND month IS NOT NULL
        SQL
      end

      # === Clean up legacy columns (safe to remove only after migration) ===
      # Remove old 'month' column if it exists and we have successfully migrated to 'period'
      remove_column :monthly_metrics, :month, :date if column_exists?(:monthly_metrics, :month)

      # Remove old 'revenue' column if it exists (replaced by 'mrr')
      remove_column :monthly_metrics, :revenue, :decimal if column_exists?(:monthly_metrics, :revenue)
    end
  end
end
