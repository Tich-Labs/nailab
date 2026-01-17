# frozen_string_literal: true

# Base policy for all RailsAdmin-managed models
class RailsAdminModelPolicy < ApplicationPolicy
  # Only admins can manage models through RailsAdmin
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
      raise Pundit::NotAuthorizedError, "Admin access required" unless user&.admin?
      scope.all
    end
  end
end
