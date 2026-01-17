# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  # Admin-only actions
  def index?
    user&.admin?
  end

  def update?
    user&.admin? || user == record
  end

  def edit?
    update?
  end

  def destroy?
    user&.admin?
  end

  def promote_to_admin?
    user&.admin?
  end

  def demote_from_admin?
    user&.admin? && user != record
  end

  # Users can view their own profile or admins can view any
  def show?
    user&.admin? || user == record
  end

  # Only admins can create users through admin interface
  def create?
    user&.admin?
  end

  def new?
    create?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user&.admin?
        scope.all
      else
        scope.where(id: user.id)
      end
    end
  end
end
