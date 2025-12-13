class Program < ApplicationRecord
  enum :category, {
    incubation: 0,
    mentorship: 1,
    funding: 2,
    research: 3,
    social_impact: 4
  }

  has_one_attached :image

  validates :title, :summary, :category, presence: true
  scope :visible, -> { where(visible: true).order(:position) }
end
