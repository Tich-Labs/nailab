class CreateMonthlyMetrics < ActiveRecord::Migration[8.1]
  def change
    create_table :monthly_metrics do |t|
      t.date :month
      t.decimal :revenue
      t.integer :customers
      t.integer :runway
      t.decimal :burn_rate
      t.references :startup, null: false, foreign_key: true

      t.timestamps
    end
  end
end
