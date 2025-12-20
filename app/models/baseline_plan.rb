class BaselinePlan < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :baseline_revenue, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :baseline_customers, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :baseline_burn_rate, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Store target milestones as JSON array
  serialize :target_milestones, coder: JSON

  def target_milestones_list
    target_milestones || []
  end

  def target_milestones_list=(value)
    self.target_milestones = value.is_a?(Array) ? value : [value].compact
  end
end
