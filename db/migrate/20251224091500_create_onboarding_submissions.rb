class CreateOnboardingSubmissions < ActiveRecord::Migration[8.1]
  def change
    create_table :onboarding_submissions, if_not_exists: true do |t|
      t.string :role, null: false
      t.string :email, null: false
      t.jsonb :payload, null: false, default: {}
      t.datetime :consented_at
      t.string :token, null: false
      t.datetime :applied_at
      t.datetime :confirmation_sent_at
      t.references :user, foreign_key: true, null: true

      t.timestamps
    end

    add_index :onboarding_submissions, :token, unique: true, if_not_exists: true
    add_index :onboarding_submissions, [:role, :email], if_not_exists: true
  end
end
