require "rails_admin/config/actions"
require "rails_admin/config/actions/base"

module RailsAdmin
  module Config
    module Actions
      class BroadcastNotifications < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :collection? do
          true
        end

        register_instance_option :http_methods do
          [ :get, :post ]
        end

        register_instance_option :controller do
          proc do
            if request.post?
              title = params[:title]
              message = params[:message]
              link = params[:link]
              CreateBroadcastNotificationsJob.perform_later(title, message, link, _current_user&.id)
              flash[:success] = "Broadcast scheduled. Notifications will be created in background."
              redirect_to back_or_index
            else
              render @action.template_name
            end
          end
        end

        register_instance_option :link_icon do
          "icon-bullhorn"
        end
      end
    end
  end
end
