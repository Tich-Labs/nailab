class PartnerApplication < ApplicationRecord
  belongs_to :user, optional: true
end
