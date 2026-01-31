class MonthlyMetric < ApplicationRecord
  # Associations
  belongs_to :startup
  belongs_to :user, optional: true

  # Temporary flags used by controller/view to relax validations for baseline rows
  attr_accessor :baseline

  # Legacy-friendly attribute aliases so older views/forms continue to work
  alias_attribute :month, :period
  alias_attribute :revenue, :mrr
  alias_attribute :users, :customers
  alias_attribute :notes, :product_progress
  alias_attribute :churn_rate, :churned_customers

  # Funding stage options (human-friendly strings stored in DB)
  FUNDING_STAGES = [
    "Bootstrapped",
    "Friends & Family",
    "Pre-Seed",
    "Seed",
    "Series A",
    "Other"
  ].freeze

  # Validations
  # Allow baseline rows (first onboarding row) to skip presence validation
  validates :mrr, :new_paying_customers, :churned_customers, :cash_at_hand, :burn_rate,
            presence: true, unless: :baseline?

  validates :mrr, :cash_at_hand, :burn_rate, :funds_raised,
            numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  validates :new_paying_customers, :churned_customers, :customers,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  validates :funding_stage, inclusion: { in: FUNDING_STAGES }, allow_nil: true

  # Normalize some legacy params (e.g. revenue -> mrr) so both old and new forms work
  before_validation :normalize_legacy_fields

  # Derived metric (not stored) — runway in months
  def runway
    return nil if burn_rate.to_f <= 0
    ((cash_at_hand.to_f + mrr.to_f) / burn_rate.to_f).round(1)
  end

  private

  def normalize_legacy_fields
    # If the legacy `revenue` attribute was submitted, copy to `mrr`.
    self.mrr = self.revenue if respond_to?(:revenue) && self.revenue.present? && self.mrr.blank?

    # Legacy `users` -> `customers`
    self.customers = self.users if respond_to?(:users) && self.users.present? && self.customers.blank?

    # Legacy `churn_rate` may be a percentage — if provided as integer, treat as churned_customers when churned_customers blank
    if respond_to?(:churn_rate) && churn_rate.present? && churned_customers.blank?
      # If churn_rate looks like a count, use it directly; otherwise leave churned_customers nil
      self.churned_customers = churn_rate.to_i
    end

    # Legacy `notes` -> `product_progress`
    self.product_progress = self.notes if respond_to?(:notes) && self.notes.present? && self.product_progress.blank?
  end

  def baseline?
    !!baseline
  end
end
