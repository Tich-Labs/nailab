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
    # Support several download sources in order of preference:
    # 1) External URL (redirect)
    # 2) Attached ActiveStorage file (stream via send_data)
    # 3) Legacy `file_path` method (if model provides it) — kept for backwards compatibility

    if @resource.url.present?
      return redirect_to @resource.url
    end

    # If a hero_image is attached, stream it to the user
    if @resource.respond_to?(:hero_image) && @resource.hero_image.attached?
      blob = @resource.hero_image
      data = blob.download
      return send_data data, filename: blob.filename.to_s, type: blob.content_type || "application/octet-stream", disposition: "attachment"
    end

    # Backwards-compatible fallback: call `file_path` if the model defines it
    if @resource.respond_to?(:file_path)
      file_path = @resource.file_path
      if file_path.present? && file_path.start_with?(Rails.root.join("storage").to_s) && File.exist?(file_path)
        return send_file file_path, type: "application/pdf", disposition: "attachment"
      end
    end

    redirect_back fallback_location: founder_resources_path, alert: "File not available for download"
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
