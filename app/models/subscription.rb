class Subscription < ApplicationRecord
  TRIAL_DAYS = 5
  TRIAL_DURATION = TRIAL_DAYS.days

  belongs_to :user

  enum :status, { trial: 0, active: 1, expired: 2, cancelled: 3 }

  validates :user_id, presence: true
  validates :status, presence: true
  validate :valid_tier_if_active

  before_create :initialize_trial

  # Scopes for common queries
  scope :active_trials, -> { where(status: :trial).where("trial_started_at > ?", TRIAL_DURATION.ago) }
  scope :expired_trials, -> { where(status: :trial).where("trial_started_at <= ?", TRIAL_DURATION.ago) }
  scope :active_subscriptions, -> { where(status: :active) }
  scope :valid_access, -> { where(status: [ :trial, :active ]) }

  # Trial lifecycle methods
  def trial_expires_at
    return nil unless trial_started_at
    trial_started_at + TRIAL_DURATION
  end

  def days_remaining
    return 0 unless trial_expires_at
    ((trial_expires_at - Time.current).to_f / 1.day).ceil
  end

  def hours_remaining
    return 0 unless trial_expires_at
    ((trial_expires_at - Time.current).to_f / 1.hour).ceil
  end

  def trial_expired?
    return false unless trial_started_at
    Time.current > trial_expires_at
  end

  def trial_active?
    status == :trial && !trial_expired?
  end

  def remind_trial_expiring?
    trial_active? && days_remaining.between?(1, 3)
  end

  def can_access_resources?
    status.in?([ :trial, :active ])
  end

  def has_valid_subscription?
    status == :active && tier.present?
  end

  # Actions
  def start_trial
    update(
      status: :trial,
      trial_started_at: Time.current,
      trial_days: TRIAL_DAYS
    )
  end

  def expire_trial
    update(status: :expired)
  end

  def activate_subscription(tier_name, payment_method = nil)
    update(
      status: :active,
      tier: tier_name,
      payment_method: payment_method,
      trial_started_at: nil # Clear trial data
    )
  end

  def cancel_subscription
    update(status: :cancelled)
  end

  def check_and_expire_trial!
    expire_trial if trial_expired? && trial_active?
  end

  private

  def initialize_trial
    self.status ||= :trial
    self.trial_started_at ||= Time.current
    self.trial_days ||= TRIAL_DAYS
  end

  def valid_tier_if_active
    return unless status == "active"
    errors.add(:tier, "must be present for active subscriptions") if tier.blank?
  end
end
