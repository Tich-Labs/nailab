class TeamMember < ApplicationRecord
  belongs_to :startup
  belongs_to :user

  enum :role, { owner: 0, admin: 1, member: 2 }

  validates :startup_id, :user_id, :role, presence: true
  validates :user_id, uniqueness: { scope: :startup_id, message: "can only be added once per startup" }
  validate :founder_must_be_owner, if: :is_founder?

  scope :owners, -> { where(role: :owner) }
  scope :admins, -> { where(role: :admin) }
  scope :members, -> { where(role: :member) }
  scope :founders, -> { where(is_founder: true) }
  scope :by_role, ->(role) { where(role: role) if role.present? }

  before_validation :ensure_role_if_founder

  # Helper methods
  def admin?
    role == "admin"
  end

  def owner?
    role == "owner"
  end

  def member?
    role == "member"
  end

  def promote_to_admin
    update(role: :admin)
  end

  def promote_to_owner
    update(role: :owner)
  end

  def demote_to_member
    update(role: :member)
  end

  private

  def ensure_role_if_founder
    self.role = :owner if is_founder? && role != "owner"
  end

  def founder_must_be_owner
    if is_founder? && role != "owner"
      errors.add(:role, "must be 'owner' for founder team members")
    end
  end
end
