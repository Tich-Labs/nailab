module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      respond_to :json
      skip_before_action :verify_authenticity_token

      private

      def respond_with(resource, _opts = {})
        if resource.persisted?
          render json: { user: resource.slice(:id, :email) }
        else
          render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end
end
