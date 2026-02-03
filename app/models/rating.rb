class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :resource

  validates :user_id, :resource_id, :score, presence: true
  validates :score, inclusion: { in: 1..5, message: "must be between 1 and 5" }
  validates :user_id, uniqueness: { scope: :resource_id, message: "can only rate a resource once" }

  before_create :set_rated_at

  scope :recent, -> { order(created_at: :desc) }
  scope :by_user, ->(user) { where(user: user) }
  scope :for_resource, ->(resource) { where(resource: resource) }
  scope :high_rated, -> { where("score >= ?", 4) }

  # Class methods for aggregation
  def self.average_score(resource_id)
    return 0 if none?
    where(resource_id: resource_id).average(:score).to_f.round(2)
  end

  def self.rating_distribution(resource_id)
    results = where(resource_id: resource_id).group(:score).count
    (1..5).each_with_object({}) { |i, h| h[i] = results[i] || 0 }
  end

  private

  def set_rated_at
    self.rated_at ||= Time.current
  end
end
