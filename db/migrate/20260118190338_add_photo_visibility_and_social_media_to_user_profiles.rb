class AddPhotoVisibilityAndSocialMediaToUserProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :user_profiles, :photo_visibility, :boolean, default: true, null: false
    add_column :user_profiles, :twitter_url, :string
    add_column :user_profiles, :other_social_url, :string
    add_column :user_profiles, :other_social_platform, :string

    # Add indexes for performance
    add_index :user_profiles, :photo_visibility
  end
end
