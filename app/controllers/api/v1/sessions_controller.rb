module Api
  module V1
    class SessionsController < Devise::SessionsController
      respond_to :json
      skip_before_action :verify_authenticity_token

      private

      def respond_with(resource, _opts = {})
        render json: { user: resource.slice(:id, :email) }
      end

      def respond_to_on_destroy
        head :no_content
      end
    end
  end
end