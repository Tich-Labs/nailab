class AddMissingFieldsToStartupProfiles < ActiveRecord::Migration[8.1]
  def change
    change_table :startup_profiles, bulk: true do |t|
      t.text :value_proposition
      t.string :funding_stage
      t.decimal :funding_raised, precision: 15, scale: 2
    end
  end
end
