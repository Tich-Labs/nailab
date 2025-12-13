class MentorshipSession < ApplicationRecord
  belongs_to :mentorship_request

  validates :date, :duration, presence: true
  validates :rating, inclusion: { in: 1..5 }, allow_nil: true
end
