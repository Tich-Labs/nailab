# frozen_string_literal: true

class MentorshipRequestPolicy < RailsAdminModelPolicy
  def show?
    user&.admin? || (user && (record.mentor == user || record.founder == user))
  end

  def index?
    user&.admin?
  end

  def create?
    user&.present?
  end

  def update?
    user&.admin? || (user && (record.mentor == user || record.founder == user))
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user&.admin?
        scope.all
      elsif user
        scope.where("mentor_id = ? OR founder_id = ?", user.id, user.id)
      else
        scope.none
      end
    end
  end
end
