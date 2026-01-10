class CreateBroadcastNotificationsJob < ApplicationJob
  queue_as :default

  def perform(title, message, link = nil, admin_id = nil)
    User.find_each(batch_size: 500) do |user|
      Notification.create!(user: user, title: title, message: message, link: link)
    end
  end
end
