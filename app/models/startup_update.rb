class StartupUpdate < ApplicationRecord
  belongs_to :startup

  validates :report_month, :report_year, :mrr, :new_paying_customers, :churned_customers, :cash_at_hand, :burn_rate, presence: true
  validates :report_month, inclusion: { in: 1..12 }
  validates :report_year, numericality: { greater_than: 2000 }
  validates :mrr, :cash_at_hand, :burn_rate, :funds_raised, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :new_paying_customers, :churned_customers, numericality: { greater_than_or_equal_to: 0 }
  validates :startup_id, uniqueness: { scope: [ :report_month, :report_year ], message: "already has an update for this month/year" }

  # Calculate runway: (cash_at_hand + mrr) / burn_rate
  def runway
    return nil if burn_rate.to_f <= 0
    ((cash_at_hand.to_f + mrr.to_f) / burn_rate.to_f).round(1)
  end
end
