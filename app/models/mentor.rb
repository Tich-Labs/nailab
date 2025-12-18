class Mentor < ApplicationRecord
  belongs_to :user

  delegate :organization, to: :user_profile, prefix: false, allow_nil: true
  delegate :full_name, to: :user_profile, prefix: false, allow_nil: true
  alias_method :company, :organization

  def role
    'Mentor'
  end

  private

  def user_profile
    user&.user_profile
  end
end
