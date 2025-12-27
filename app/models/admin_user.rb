
class AdminUser < ApplicationRecord
  # Enable Devise modules including :trackable for sign-in tracking
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :trackable

  # Allowlist attributes for Ransack/ActiveAdmin search
  def self.ransackable_attributes(auth_object = nil)
    [
      "id",
      "email",
      "created_at",
      "updated_at",
      "remember_created_at",
      "reset_password_sent_at",
      "current_sign_in_at",
      "sign_in_count"
    ]
  end
end
