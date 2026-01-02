class Founder::ResourcesController < Founder::BaseController
  before_action :set_resource, only: %i[show bookmark rate download]

  def index
    @resources = Resource.all
  end

  def show
  end

  def bookmark
    current_user.bookmarks.create(resource: @resource)
    redirect_back fallback_location: founder_resources_path, notice: "Bookmarked."
  end

  def rate
    @resource.ratings.create(user: current_user, score: params[:score])
    redirect_back fallback_location: founder_resource_path(@resource), notice: "Rated."
  end

  def download
    # stub download logic
    send_file @resource.file_path, type: "application/pdf", disposition: "attachment"
  end

  private

  def set_resource
    @resource = Resource.find(params[:id])
  end
end
