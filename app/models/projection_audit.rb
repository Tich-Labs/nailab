class ProjectionAudit < ApplicationRecord
  belongs_to :startup
  belongs_to :user, optional: true
  validates :period, :field, presence: true
end
