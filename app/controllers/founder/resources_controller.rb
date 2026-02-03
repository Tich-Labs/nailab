begin
  require "zip"
  ZIP_AVAILABLE = true
rescue LoadError
  ZIP_AVAILABLE = false
end

class Founder::ResourcesController < Founder::BaseController
  before_action :set_resource, only: %i[show bookmark rate download]

  # Download all templates as a single ZIP. If the 'zip' library isn't available
  # on the host, we fail gracefully with a friendly message.
  def download_all_templates
    unless ZIP_AVAILABLE
      redirect_back fallback_location: founder_resources_path, alert: "Zip library not available on this server"
      return
    end

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
            begin
              file_data = URI.open(resource.url).read
              zip.put_next_entry(filename)
              zip.write file_data
            rescue => _e
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

  def index
    @resource_types = Resource.distinct.pluck(:resource_type).compact.sort
    @selected_type = params[:resource_type]
    @search = params[:search]
    @bookmarked_only = params[:bookmarked] == "1"

    # Base query with access control
    @resources = Resource.all

    # Filter by type
    @resources = @resources.by_type(@selected_type) if @selected_type.present?

    # Filter by search
    @resources = @resources.searchable(@search) if @search.present?

    # Filter by bookmarked
    if @bookmarked_only && current_user
      @resources = @resources.joins(:bookmarks).where(bookmarks: { user_id: current_user.id }).distinct
    end

    # Apply subscription access control
    @resources = filter_by_access(@resources)

    # Cache bookmarked IDs for quick lookup
    @bookmarked_ids = current_user ? current_user.bookmarks.pluck(:resource_id) : []

    # Add trial reminder to instance variables
    @subscription = current_user&.subscription
    @trial_message = trial_message_for_user if @subscription&.remind_trial_expiring?
  end

  def show
    unless @resource.accessible_by?(current_user)
      redirect_to founder_resources_path, alert: @resource.access_denied_message
      nil
    end
  end

  def bookmark
    current_user.bookmarks.create(resource: @resource)
    respond_to do |format|
      format.html { redirect_back fallback_location: founder_resources_path, notice: "Bookmarked." }
      format.json { render json: { success: true } }
    end
  end

  def rate
    # Prevent duplicate ratings
    existing_rating = @resource.ratings.find_by(user: current_user)

    if existing_rating
      # Update existing rating
      existing_rating.update(score: params[:score])
      message = "Rating updated."
    else
      # Create new rating
      @resource.ratings.create(user: current_user, score: params[:score])
      message = "Thank you for rating this resource."
    end

    redirect_back fallback_location: founder_resource_path(@resource), notice: message
  rescue ActiveRecord::RecordInvalid => e
    redirect_back fallback_location: founder_resource_path(@resource), alert: e.message
  end

  def download
    unless @resource.accessible_by?(current_user)
      redirect_to founder_resources_path, alert: @resource.access_denied_message
      return
    end

    if @resource.url.present?
      return redirect_to @resource.url
    end

    if @resource.respond_to?(:hero_image) && @resource.hero_image.attached?
      blob = @resource.hero_image
      data = blob.download
      return send_data data, filename: blob.filename.to_s, type: blob.content_type || "application/octet-stream", disposition: "attachment"
    end

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
    lookup = params[:id] || params[:slug]
    @resource = Resource.find_by(slug: lookup) || Resource.find_by(id: lookup)
    unless @resource
      redirect_to founder_resources_path, alert: "Resource not found"
    end
  end

  def filter_by_access(resources)
    if current_user&.subscription&.can_access_resources?
      # User has valid subscription, show all
      resources
    else
      # Show only free resources
      resources.free_resources
    end
  end

  def check_trial_status
    return unless current_user
    current_user.subscription&.check_and_expire_trial!
  end

  def trial_message_for_user
    subscription = current_user.subscription
    return nil unless subscription

    if subscription.remind_trial_expiring?
      "Your free trial expires in #{subscription.days_remaining} day(s). Upgrade now to continue access to premium resources."
    elsif subscription.trial_expired?
      "Your trial has expired. Subscribe to continue using premium resources."
    end
  end
end
