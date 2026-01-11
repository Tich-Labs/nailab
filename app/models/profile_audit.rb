class ProfileAudit < ApplicationRecord
  belongs_to :user_profile
  belongs_to :admin, class_name: "User"
  validates :action, presence: true
end
