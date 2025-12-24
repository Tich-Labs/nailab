class FounderApplication < ApplicationRecord
  validates :name, :email, :startup_name, presence: true
end