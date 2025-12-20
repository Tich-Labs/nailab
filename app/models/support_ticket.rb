class SupportTicket < ApplicationRecord
  STATUSES = %w[open in_progress resolved closed].freeze

  belongs_to :user

  validates :subject, :category, :description, presence: true
  validates :status, inclusion: { in: STATUSES }
end
