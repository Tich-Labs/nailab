class StaticPage < ApplicationRecord
  # title: string
  # slug: string (unique, e.g. 'about', 'pricing', 'contact')
  # content: text (HTML or markdown)
  validates :slug, presence: true, uniqueness: true
  validates :title, presence: true

  attribute :structured_content, :jsonb, default: -> { {} }
end
