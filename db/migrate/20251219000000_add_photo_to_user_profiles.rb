class AddPhotoToUserProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :user_profiles, :photo, :string
  end
end
