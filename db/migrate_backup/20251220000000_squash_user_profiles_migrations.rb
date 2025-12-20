class SquashUserProfilesMigrations < ActiveRecord::Migration[8.1]
  def change
    change_table :user_profiles, bulk: true do |t|
      t.string :phone unless column_exists?(:user_profiles, :phone)
      t.string :country unless column_exists?(:user_profiles, :country)
      t.string :city unless column_exists?(:user_profiles, :city)
      t.text :advisory_description unless column_exists?(:user_profiles, :advisory_description)
      t.string :photo unless column_exists?(:user_profiles, :photo)
      t.string :onboarding_step unless column_exists?(:user_profiles, :onboarding_step)
    end
  end
end