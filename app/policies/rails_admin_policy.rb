# frozen_string_literal: true

class RailsAdminPolicy < ApplicationPolicy
  # Only true admins can access RailsAdmin
  def index?
    user&.admin?
  end

  def show?
    user&.admin?
  end

  def new?
    user&.admin?
  end

  def create?
    user&.admin?
  end

  def edit?
    user&.admin?
  end

  def update?
    user&.admin?
  end

  def destroy?
    user&.admin?
  end

  def export?
    user&.admin?
  end

  def history?
    user&.admin?
  end

  def show_in_app?
    user&.admin?
  end

  def bulk_delete?
    user&.admin?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      raise Pundit::NotAuthorizedError, "Admin access required for RailsAdmin" unless user&.admin?
      scope.all
    end
  end
end
