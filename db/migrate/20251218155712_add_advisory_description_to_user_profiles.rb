class AddAdvisoryDescriptionToUserProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :user_profiles, :advisory_description, :text
  end
end
