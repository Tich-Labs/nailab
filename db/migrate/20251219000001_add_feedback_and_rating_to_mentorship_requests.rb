class AddFeedbackAndRatingToMentorshipRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :mentorship_requests, :feedback, :text
    add_column :mentorship_requests, :rating, :integer
  end
end