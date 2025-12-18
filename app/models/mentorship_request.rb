class MentorshipRequest < ApplicationRecord
  enum :status, { pending: 'pending', accepted: 'accepted', declined: 'declined', reschedule_requested: 'reschedule_requested' }, suffix: true

  belongs_to :founder, class_name: 'User'
  belongs_to :mentor, class_name: 'User'

  scope :for_mentor, ->(mentor_id) { where(mentor_id: mentor_id).order(created_at: :desc) }
  scope :recent, -> { order(created_at: :desc) }

  def accept!(responded_at_stamp = Time.current)
    update!(status: :accepted, responded_at: responded_at_stamp)
  end

  def decline!(reason:, responded_at_stamp: Time.current)
    update!(status: :declined, decline_reason: reason, responded_at: responded_at_stamp)
  end

  def propose_reschedule!(proposed_time:, reason:, requested_at: Time.current)
    update!(status: :reschedule_requested, reschedule_reason: reason, reschedule_requested_at: requested_at, proposed_time: proposed_time)
  end
end
