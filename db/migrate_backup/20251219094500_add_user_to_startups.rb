class AddUserToStartups < ActiveRecord::Migration[8.1]
  def change
    return if column_exists?(:startups, :user_id)

    change_table :startups, bulk: true do |t|
      t.references :user, foreign_key: true, index: true
    end
  end
end
