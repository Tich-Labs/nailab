class AddProfileApprovalToUserProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :user_profiles, :profile_approval_status, :string, null: false, default: 'pending'
    add_column :user_profiles, :profile_rejection_reason, :text
    add_index :user_profiles, :profile_approval_status
  end
end
