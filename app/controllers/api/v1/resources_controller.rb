module Api
  module V1
    class ResourcesController < PublicController
      def index
        resources = Resource.where(active: true)
        resources = resources.where(resource_type: params[:category]) if params[:category].present?
        if params[:search].present?
          resources = resources.where("title ILIKE ?", "%#{params[:search]}%")
        end
        resources = resources.order(published_at: :desc)
        render_collection(resources, Serializers::ResourceSerializer)
      end
    end
  end
end
