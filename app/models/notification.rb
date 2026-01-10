class Notification < ApplicationRecord
  belongs_to :user

  after_create :broadcast_create

  private

  def broadcast_create
    # Broadcast to the user's personal notifications stream
    begin
      ActionCable.server.broadcast("notifications:#{user_id}", {
        id: id,
        title: title,
        message: message,
        link: link,
        unread_count: user.notifications.where(read: false).count
      })
    rescue => _e
      # don't let a broadcast failure block the request
    end
  end
end
