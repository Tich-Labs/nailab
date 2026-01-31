  require "zip"
  def download_all_templates
    templates = Resource.where(resource_type: "template")
    if templates.empty?
      redirect_back fallback_location: founder_resources_path, alert: "No templates available for download"
      return
    end

    temp_file = Tempfile.new([ "templates-", ".zip" ])
    begin
      Zip::OutputStream.open(temp_file.path) do |zip|
        templates.each do |resource|
          filename = resource.title.parameterize + File.extname(resource.url || resource.hero_image&.filename&.to_s || ".pdf")
          if resource.url.present?
            # Download from external URL
            begin
              file_data = URI.open(resource.url).read
              zip.put_next_entry(filename)
              zip.write file_data
            rescue => e
              # skip if download fails
            end
          elsif resource.respond_to?(:hero_image) && resource.hero_image.attached?
            zip.put_next_entry(filename)
            zip.write resource.hero_image.download
          elsif resource.respond_to?(:file_path) && resource.file_path.present? && File.exist?(resource.file_path)
            zip.put_next_entry(filename)
            zip.write File.read(resource.file_path)
          end
        end
      end
      temp_file.rewind
      send_data temp_file.read, filename: "nailab-templates.zip", type: "application/zip", disposition: "attachment"
    ensure
      temp_file.close
      temp_file.unlink
    end
  end
class Founder::ResourcesController < Founder::BaseController
  before_action :set_resource, only: %i[show bookmark rate download]

  def index
    premium_titles = [
      "Scaling Your African Startup: A Fireside Chat with Flutterwave Founders",
      "Fundraising Checklist: From Seed to Series A",
      "Building Scalable Startups in Africa: Lessons from Flutterwave",
      "Google for Startups Founders Funds - Africa 2025"
    ]
    @resource_types = Resource.distinct.pluck(:resource_type).compact.sort
    @selected_type = params[:resource_type]
    @search = params[:search]
    @bookmarked_only = params[:bookmarked] == "1"
    @resources = Resource.all
    @resources = @resources.where(resource_type: @selected_type) if @selected_type.present?
    @resources = @resources.where("title ILIKE ?", "%#{@search}%") if @search.present?
    if @bookmarked_only && current_user
      @resources = @resources.joins(:bookmarks).where(bookmarks: { user_id: current_user.id })
    end
    # Founders see all resources, including premium
    @bookmarked_ids = current_user ? current_user.bookmarks.pluck(:resource_id) : []
  end

  def show
  end

  def bookmark
    current_user.bookmarks.create(resource: @resource)
    respond_to do |format|
      format.html { redirect_back fallback_location: founder_resources_path, notice: "Bookmarked." }
      format.json { render json: { success: true } }
    end
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
    # Allow lookup by slug (friendly url), numeric id, or param :slug
    lookup = params[:id] || params[:slug]
    @resource = Resource.find_by(slug: lookup) || Resource.find_by(id: lookup)
    unless @resource
      redirect_to founder_resources_path, alert: "Resource not found"
    end
  end
end
