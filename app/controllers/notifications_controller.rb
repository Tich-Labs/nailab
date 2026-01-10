class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.order(created_at: :desc)
  end

  def mark_all_read
    current_user.notifications.where(read: false).update_all(read: true, updated_at: Time.current)
    render json: { success: true, unread_count: 0 }
  end

  def mark_read
    n = current_user.notifications.find(params[:id])
    n.update!(read: true) unless n.read?

    respond_to do |format|
      format.html do
        if n.link.present?
          redirect_to n.link
        else
          redirect_to notifications_path, notice: "Notification marked read"
        end
      end
      format.json do
        render json: { success: true, redirect: n.link.presence }
      end
    end
  end
end
