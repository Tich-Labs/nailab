class HomepageSection < ApplicationRecord
  enum :section_type, { hero: 0, features: 1, stats: 2, cta: 3, about_snapshot: 4, focus_areas: 5 }

  has_rich_text :content

  validates :title, :section_type, presence: true
  scope :visible, -> { where(visible: true).order(:position) }
end
