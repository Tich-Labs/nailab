class DeletedAccount < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  before_validation do
    self.email = email.to_s.downcase.strip
  end
end
