class AddCountryAndCityToUserProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :user_profiles, :country, :string
    add_column :user_profiles, :city, :string
  end
end
