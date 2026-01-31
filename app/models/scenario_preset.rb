class ScenarioPreset < ApplicationRecord
  belongs_to :user, optional: true
  validates :name, presence: true
  validates :growth_pct, :churn_pct, :burn_change_pct, presence: true
end
