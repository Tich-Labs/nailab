class ExpandStartupProfiles < ActiveRecord::Migration[8.1]
  def change
    change_table :startup_profiles do |t|
      t.text :target_market
      t.text :value_proposition
      t.string :funding_stage
      t.decimal :funding_raised, precision: 14, scale: 2
      t.text :challenge_details
      t.string :preferred_mentorship_mode
      t.string :phone_number
      t.string :logo_url
      t.integer :team_size, default: 0
    end
  end
end
