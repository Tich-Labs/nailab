# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  protected

  # Helper methods for role-based authorization
  def admin?
    user&.admin?
  end

  def mentor?
    user&.mentor?
  end

  def founder?
    user&.founder?
  end

  def partner?
    user&.partner?
  end

  def owner?
    user && record.respond_to?(:user) && record.user == user
  end

  def owns_resource?
    user == record
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end
