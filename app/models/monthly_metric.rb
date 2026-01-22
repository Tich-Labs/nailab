class MonthlyMetric < ApplicationRecord
  belongs_to :startup

  validates :period, presence: true, uniqueness: { scope: :startup_id }
  validates :mrr, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validates :new_paying_customers, numericality: { greater_than_or_equal_to: 0, allow_nil: true, only_integer: true }
  validates :churned_customers, numericality: { greater_than_or_equal_to: 0, allow_nil: true, only_integer: true }
  validates :cash_at_hand, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validates :burn_rate, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validates :funds_raised, numericality: { greater_than_or_equal_to: 0, allow_nil: true }

  def runway_in_months
    return Float::INFINITY if burn_rate.to_f.zero?
    return 0 if cash_at_hand.to_f.negative?

    ((cash_at_hand || 0) + (mrr || 0)) / burn_rate
  end
end
