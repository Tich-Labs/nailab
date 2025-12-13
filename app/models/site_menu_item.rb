class SiteMenuItem < ApplicationRecord
  enum :location, { header: 0, footer: 1 }

  validates :title, :path, :location, presence: true
  scope :visible, -> { where(visible: true).order(:position) }
end
