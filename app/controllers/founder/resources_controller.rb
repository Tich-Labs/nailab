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
    # Validate file path to prevent directory traversal
    file_path = @resource.file_path
    return redirect_back(alert: "Invalid file") unless file_path&.start_with?(Rails.root.join("storage").to_s)
    return redirect_back(alert: "File not found") unless File.exist?(file_path)

    send_file file_path, type: "application/pdf", disposition: "attachment"
  end

  private

  def set_resource
    # Allow lookup by slug (friendly url) or numeric id.
    @resource = Resource.find_by(slug: params[:id]) || Resource.find_by(id: params[:id])
    unless @resource
      redirect_to founder_resources_path, alert: "Resource not found"
    end
  end
end
