class Connection < ApplicationRecord
  belongs_to :user
  belongs_to :peer, class_name: "User"
end
