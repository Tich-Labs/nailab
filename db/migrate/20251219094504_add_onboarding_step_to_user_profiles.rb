class AddOnboardingStepToUserProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :user_profiles, :onboarding_step, :string
  end
end
