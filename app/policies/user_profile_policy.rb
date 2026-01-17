# frozen_string_literal: true

class UserProfilePolicy < ApplicationPolicy
  # Users can view public profiles, but private info requires authorization
  def show?
    # Users can view their own profile
    return true if user == record.user

    # Admins can view any profile
    return true if user&.admin?

    # Mentors can view founder profiles (for mentorship purposes)
    return true if user&.mentor? && record.user&.founder?

    # Profiles that are marked public can be viewed by anyone
    record.profile_visibility?
  end

  def update?
    # Users can update their own profile
    return true if user == record.user

    # Admins can update any profile
    user&.admin?
  end

  def edit?
    update?
  end

  def create?
    # Users can create their own profile
    return true if user&.present?

    # Admins can create profiles
    user&.admin?
  end

  def new?
    create?
  end

  # Approval actions - admin only
  def approve?
    user&.admin?
  end

  def reject?
    user&.admin?
  end

  def deactivate?
    user&.admin? || user == record.user
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user&.admin?
        # Admins see all profiles
        scope.all
      elsif user&.mentor?
        # Mentors see public founder profiles
        scope.joins(:user)
             .where(user_profiles: { profile_visibility: true })
             .where(users: { role: "founder" })
      elsif user&.founder?
        # Founders see public mentor profiles
        scope.joins(:user)
             .where(user_profiles: { profile_visibility: true })
             .where(users: { role: "mentor" })
      else
        # Others see only public profiles
        scope.where(profile_visibility: true)
      end
    end
  end
end
