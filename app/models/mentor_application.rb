class MentorApplication < ApplicationRecord
  validates :name, :email, presence: true
end