class AddCommitmentLengthToMentorshipRequests < ActiveRecord::Migration[8.1]
  def change
    add_column :mentorship_requests, :commitment_length, :string
  end
end
