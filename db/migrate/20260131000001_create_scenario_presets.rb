class CreateScenarioPresets < ActiveRecord::Migration[7.0]
  def change
    unless table_exists?(:scenario_presets)
      create_table :scenario_presets do |t|
        t.string :name, null: false
        t.decimal :growth_pct, precision: 5, scale: 2, default: 8.0
        t.decimal :churn_pct, precision: 5, scale: 2, default: 2.0
        t.decimal :burn_change_pct, precision: 5, scale: 2, default: 0.0
        t.bigint :user_id
        t.timestamps
      end
      add_index :scenario_presets, :user_id

      reversible do |dir|
        dir.up do
          execute <<-SQL.squish
            INSERT INTO scenario_presets (name, growth_pct, churn_pct, burn_change_pct, created_at, updated_at)
            VALUES
              ('Optimistic', 20.0, 1.0, -5.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
              ('Realistic', 8.0, 2.0, 0.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
              ('Pessimistic', -5.0, 4.0, 5.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
          SQL
        end
      end
    end
  end
end
