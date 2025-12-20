class Conversation < ApplicationRecord
  belongs_to :user
  belongs_to :mentor

  def other_participant(current_user)
    if user == current_user
      mentor
    else
      user
    end
  end
end
