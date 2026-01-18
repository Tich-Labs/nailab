# Minimal base policy used by RailsAdmin-related model policies.
# Provides sensible defaults (admin-only) for common actions so eager-load
# doesn't fail when these policies are referenced during boot.
class RailsAdminModelPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user&.admin?
  end

  def show?
    index?
  end

  def create?
    index?
  end

  def new?
    create?
  end

  def update?
    index?
  end

  def edit?
    update?
  end

  def destroy?
    index?
  end

  def export?
    index?
  end
end
