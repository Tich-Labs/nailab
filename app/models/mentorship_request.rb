class MentorshipRequest < ApplicationRecord
  belongs_to :founder, class_name: 'User'
  belongs_to :mentor, class_name: 'User'
end
