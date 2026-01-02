class Faq < ApplicationRecord
  scope :active, -> { where(active: true) }

  validates :question, :answer, presence: true
end
