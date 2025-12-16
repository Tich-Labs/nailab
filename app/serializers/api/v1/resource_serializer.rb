module Api
  module V1
    module Serializers
      class ResourceSerializer
        def initialize(resource)
          @resource = resource
        end

        def to_h
          {
            id: resource.id,
            title: resource.title,
            description: resource.description,
            url: resource.url,
            category: resource.resource_type,
            resource_type: resource.resource_type,
            published_at: resource.published_at
          }
        end

        private

        attr_reader :resource
      end
    end
  end
end
