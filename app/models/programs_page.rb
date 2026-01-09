class ProgramsPage < ApplicationRecord
  has_rich_text :intro

  has_many :program_sections, -> { order(:position) }, dependent: :destroy
  accepts_nested_attributes_for :program_sections, allow_destroy: true, reject_if: :all_blank
end
