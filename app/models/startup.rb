class Startup < ApplicationRecord
  belongs_to :user
  has_many :startup_updates, dependent: :destroy
  has_many :monthly_metrics, dependent: :destroy
  has_many :startup_invites, dependent: :destroy
end
