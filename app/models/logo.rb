class Logo < ApplicationRecord
  has_one_attached :image

  validates :image, attached: true, content_type: %r{\Aimage/.*\z}
  scope :active, -> { where(active: true) }
  default_scope { order(:display_order) }
end
