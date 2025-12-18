class MentorshipRequest < ApplicationRecord
  belongs_to :founder, class_name: 'User'
  belongs_to :mentor
end
