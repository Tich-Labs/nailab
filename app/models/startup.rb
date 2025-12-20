class Startup < ApplicationRecord
  belongs_to :user
  has_many :milestones, dependent: :destroy
  has_many :monthly_metrics, dependent: :destroy
end
