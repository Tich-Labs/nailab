module Api
  module V1
    class PublicController < ApplicationController
      respond_to :json
      skip_before_action :verify_authenticity_token

      private

      def render_collection(records, serializer_class)
        render json: records.map { |record| serializer_class.new(record).to_h }
      end

      def render_resource(resource, serializer_class)
        render json: serializer_class.new(resource).to_h
      end
    end
  end
end
