module Admin
  class ResourcesController < ApplicationController
    include AdminAuthorization
    before_action :set_resource, only: [ :edit, :update, :destroy, :preview ]

    def index
      @resources = Resource.order(created_at: :desc)
    end

    def new
      @resource = Resource.new
    end

    def create
      @resource = Resource.new(resource_params)
      if @resource.save
        redirect_to admin_resources_path, notice: "Resource created successfully."
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @resource.update(resource_params)
        redirect_to admin_resources_path, notice: "Resource updated successfully."
      else
        render :edit
      end
    end

    def destroy
      @resource.destroy
      redirect_to admin_resources_path, notice: "Resource deleted."
    end

    def preview
      # Renders a preview using the shared partial
      render partial: "pages/resources/resource_detail", locals: { resource: @resource }
    end

    private
    def set_resource
      @resource = Resource.find_by!(slug: params[:id])
    end

    def resource_params
      params.require(:resource).permit(
        :title, :description, :content, :resource_type, :published_at, :slug, :url, :active, :hero_image_url,
        :hero_image,
        inline_images: [],
        inline_image_urls: []
      )
    end
  end
end
