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

    unless column_exists?(:monthly_metrics, :cash_at_hand)
      add_column :monthly_metrics, :cash_at_hand, :decimal, precision: 10, scale: 2
    end

    unless column_exists?(:monthly_metrics, :burn_rate)
      add_column :monthly_metrics, :burn_rate, :decimal
    end

    unless column_exists?(:monthly_metrics, :mrr)
      add_column :monthly_metrics, :mrr, :decimal
    end

    unless column_exists?(:monthly_metrics, :period)
      add_column :monthly_metrics, :period, :date
    end

    unless column_exists?(:monthly_metrics, :runway)
      add_column :monthly_metrics, :runway, :integer
    end

    unless column_exists?(:monthly_metrics, :product_progress)
      add_column :monthly_metrics, :product_progress, :text
    end

    unless column_exists?(:monthly_metrics, :funding_stage)
      add_column :monthly_metrics, :funding_stage, :string
    end

    unless column_exists?(:monthly_metrics, :funds_raised)
      add_column :monthly_metrics, :funds_raised, :decimal, precision: 10, scale: 2
    end

    unless column_exists?(:monthly_metrics, :investors_engaged)
      add_column :monthly_metrics, :investors_engaged, :string
    end

    unless column_exists?(:monthly_metrics, :is_projection)
      add_column :monthly_metrics, :is_projection, :boolean, default: false, null: false
    end

    unless column_exists?(:monthly_metrics, :projection_index)
      add_column :monthly_metrics, :projection_index, :integer
    end
  end
end
