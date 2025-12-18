class AddMentorFieldsToUserProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :user_profiles, :mentorship_approach, :text
    add_column :user_profiles, :motivation, :text
    add_column :user_profiles, :professional_website, :string
    add_column :user_profiles, :currency, :string
  end
end
