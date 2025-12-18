class OpportunitySubmission < ApplicationRecord
  belongs_to :opportunity
  belongs_to :user
end
