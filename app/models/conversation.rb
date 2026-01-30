
class Conversation < ApplicationRecord
  belongs_to :user
  belongs_to :mentor
  has_many :messages, dependent: :destroy

  def other_participant(current_user)
    if user == current_user
      mentor
    else
      user
    end
  end
end
