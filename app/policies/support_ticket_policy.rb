# frozen_string_literal: true

class SupportTicketPolicy < RailsAdminModelPolicy
  # Support tickets have special rules for admins
  def show?
    user&.admin? || (user && record.user == user)
  end

  def index?
    user&.admin?
  end

  def create?
    user&.present?  # Any logged-in user can create tickets
  end

  def update?
    user&.admin? || (user && record.user == user)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user&.admin?
        scope.all
      elsif user
        scope.where(user: user)
      else
        scope.none
      end
    end
  end
end
