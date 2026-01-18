class AdminPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def access?
    user&.admin?
  end

  def dashboard?
    access?
  end

  def manage_support_tickets?
    access?
  end

  def manage_user_profiles?
    access?
  end
end
