class Category < ApplicationRecord
  before_validation :set_slug, on: :create
  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  has_and_belongs_to_many :programs, join_table: :categories_programs

  def to_param
    slug
  end

  private

  def set_slug
    self.slug ||= name.to_s.parameterize if slug.blank? && name.present?
  end
end
