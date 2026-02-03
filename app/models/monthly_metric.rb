class MonthlyMetric < ApplicationRecord
  belongs_to :startup
  belongs_to :user, optional: true

  attr_accessor :baseline

  # Legacy-friendly attribute aliases
  alias_attribute :month, :period
  alias_attribute :revenue, :mrr
  alias_attribute :users, :customers
  alias_attribute :notes, :product_progress
  alias_attribute :churn_rate, :churned_customers if column_names.include?("churned_customers")

  FUNDING_STAGES = [ "Bootstrapped", "Friends & Family", "Pre-Seed", "Seed", "Series A", "Other" ].freeze

  # Require at least one meaningful metric for non-baseline rows so founders can save partial months
  validate :must_have_at_least_one_metric, unless: :baseline?

  validates :mrr, :cash_at_hand, :burn_rate, :funds_raised,
            numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  validates :new_paying_customers, :churned_customers, :customers,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  validates :funding_stage, inclusion: { in: FUNDING_STAGES }, allow_nil: true

  before_validation :normalize_legacy_fields

  def runway
    return nil if burn_rate.to_f <= 0
    ((cash_at_hand.to_f + mrr.to_f) / burn_rate.to_f).round(1)
  end

  private

  def normalize_legacy_fields
    self.mrr = revenue if respond_to?(:revenue) && revenue.present? && mrr.blank?
    self.customers = users if respond_to?(:users) && users.present? && customers.blank?
    self.churned_customers = churn_rate.to_i if respond_to?(:churn_rate) && churn_rate.present? && churned_customers.blank?
    self.product_progress = notes if respond_to?(:notes) && notes.present? && product_progress.blank?
  end

  def baseline?
    !!baseline
  end

  def must_have_at_least_one_metric
    if mrr.blank? && new_paying_customers.blank? && churned_customers.blank? && cash_at_hand.blank? && burn_rate.blank?
      errors.add(:base, "Please provide at least one metric (MRR, new customers, churned customers, cash at hand or burn rate)")
    end
  end
end
