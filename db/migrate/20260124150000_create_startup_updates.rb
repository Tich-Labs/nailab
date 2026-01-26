class CreateStartupUpdates < ActiveRecord::Migration[7.0]
  def change
    create_table :startup_updates do |t|
      t.references :startup, null: false, foreign_key: true
      t.integer :report_month, null: false
      t.integer :report_year, null: false
      t.decimal :mrr, precision: 12, scale: 2, null: false
      t.integer :new_paying_customers, null: false
      t.integer :churned_customers, null: false
      t.decimal :cash_at_hand, precision: 15, scale: 2, null: false
      t.decimal :burn_rate, precision: 12, scale: 2, null: false
      t.text :product_progress
      t.string :funding_stage
      t.decimal :funds_raised, precision: 15, scale: 2
      t.string :investors_engaged
      t.timestamps
    end
    add_index :startup_updates, [ :startup_id, :report_month, :report_year ], unique: true, name: 'index_startup_updates_on_startup_and_month_year'
  end
end
