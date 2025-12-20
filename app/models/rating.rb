class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :resource

  validates :user_id, uniqueness: { scope: :resource_id, message: "already rated this resource" }
  validates :score, inclusion: { in: 1..5 }
end
