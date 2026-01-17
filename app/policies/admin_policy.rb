# frozen_string_literal: true

class AdminPolicy < ApplicationPolicy
  # Only admin users can access any admin functionality
  def access?
    user&.admin?
  end

  # Dashboard access
  def dashboard?
    user&.admin?
  end

  # User profile management
  def manage_user_profiles?
    user&.admin?
  end

  def approve_profile?
    user&.admin?
  end

  def reject_profile?
    user&.admin?
  end

  # Support ticket management
  def manage_support_tickets?
    user&.admin?
  end

  # Content management
  def manage_content?
    user&.admin?
  end

  # Analytics and reporting
  def view_analytics?
    user&.admin?
  end

  # System administration
  def system_settings?
    user&.admin?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      raise Pundit::NotAuthorizedError, "Admin access required" unless user&.admin?
      scope.all
    end
  end
end
