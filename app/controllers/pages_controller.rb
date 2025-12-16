class PagesController < ApplicationController
  PROGRAM_CATEGORIES = [
    'Startup Incubation & Acceleration',
    'Masterclasses & Mentorship',
    'Funding Access',
    'Research & Development',
    'Social Impact Programs'
  ].freeze

  RESOURCE_CATEGORY_OPTIONS = [
    { slug: 'all', value: 'all', label: 'All Resources' },
    { slug: 'blogs', value: 'blog', label: 'Blogs' },
    { slug: 'knowledge-hub', value: 'template', label: 'Knowledge Hub' },
    { slug: 'opportunities', value: 'opportunity', label: 'Opportunities' },
    { slug: 'events', value: 'event', label: 'Events & Webinars' }
  ].freeze

  STARTUP_STAGE_OPTIONS = [
    { value: 'idea', label: 'Idea Stage' },
    { value: 'mvp', label: 'Early Stage' },
    { value: 'growth', label: 'Growth Stage' },
    { value: 'scale', label: 'Scaling Stage' }
  ].freeze

  FUNDING_STAGE_LABELS = {
    'bootstrapped' => 'Bootstrapped',
    'friends_family' => 'Friends & Family',
    'angel' => 'Angel',
    'pre_seed' => 'Pre-seed',
    'seed' => 'Seed',
    'series_a' => 'Series A',
    'series_b_plus' => 'Series B+'
  }.freeze

  helper_method :startup_stage_label, :funding_stage_label

  def home
    @hero_slides = HeroSlide.where(active: true).order(:display_order)
    @partners = Partner.where(active: true).order(:display_order)
    @testimonials = Testimonial.where(active: true).order(:display_order)
    @focus_areas = FocusArea.where(active: true).order(:display_order)
    @program_highlights = Program.where(active: true).order(start_date: :desc).limit(3)
    @resources = Resource.where(active: true).order(published_at: :desc).limit(3)
    @startups = StartupProfile.where(active: true).order(:startup_name).limit(4)
  end

  def login; end

  def signup; end

  def about
    @static_page = StaticPage.find_by(slug: 'about')
  end

  def programs
    @program_categories = PROGRAM_CATEGORIES
    selected_category = params[:category]
    @programs = if selected_category.present? && PROGRAM_CATEGORIES.include?(selected_category)
      Program.where(active: true, category: selected_category)
    else
      Program.where(active: true)
    end.order(start_date: :desc)
  end

  def program_detail
    @program = Program.find_by(slug: params[:slug], active: true)
    return redirect_to programs_path, alert: 'Program not found' if @program.nil?
  end

  def resources
    @resource_categories = RESOURCE_CATEGORY_OPTIONS
    incoming_category = params[:category].presence
    selected_option = RESOURCE_CATEGORY_OPTIONS.find { |option| option[:slug] == incoming_category }
    selected_option ||= RESOURCE_CATEGORY_OPTIONS.find { |option| option[:value] == incoming_category }
    @selected_category = selected_option ? selected_option[:slug] : 'all'
    search_term = params[:q]&.strip
    base_scope = Resource.where(active: true)
    filtered_value = selected_option.present? ? selected_option[:value] : 'all'
    scoped = if filtered_value == 'all'
      base_scope
    else
      base_scope.where(resource_type: filtered_value)
    end
    @search_query = search_term
    @resources = if search_term.present?
      term = "%#{search_term.downcase}%"
      scoped.where('LOWER(title) LIKE ? OR LOWER(description) LIKE ?', term, term)
    else
      scoped
    end.order(published_at: :desc)
  end

  def resource_detail
    active_resources = Resource.where(active: true)
    @resource = active_resources.detect { |resource| resource.slug == params[:slug] }
    return redirect_to resources_path, alert: 'Resource not found' if @resource.nil?

    category_option = RESOURCE_CATEGORY_OPTIONS.find { |option| option[:value] == @resource.resource_type }
    @resource_category_slug = category_option ? category_option[:slug] : 'all'
    @related_resources = active_resources.where.not(id: @resource.id).order(published_at: :desc).limit(4)
  end

  def startup_directory
    base_scope = StartupProfile.where(active: true)
    @filters = {
      search: params[:q]&.strip,
      sector: params[:sector],
      stage: params[:stage],
      location: params[:location]&.strip
    }
    @sector_options = base_scope.where.not(sector: [nil, '']).distinct.order(:sector).pluck(:sector)
    @stage_options = STARTUP_STAGE_OPTIONS

    scoped = base_scope.order(:startup_name)
    if @filters[:sector].present?
      scoped = scoped.where(sector: @filters[:sector])
    end
    if @filters[:stage].present?
      scoped = scoped.where(stage: @filters[:stage])
    end
    if @filters[:location].present?
      scoped = scoped.where('LOWER(location) LIKE ?', "%#{@filters[:location].downcase}%")
    end
    if @filters[:search].present?
      term = "%#{@filters[:search].downcase}%"
      scoped = scoped.where('LOWER(startup_name) LIKE :term OR LOWER(description) LIKE :term OR LOWER(sector) LIKE :term', term: term)
    end

    @filtered_startups = scoped
  end

  def mentor_directory
    base_scope = UserProfile.where(role: 'mentor', profile_visibility: true)
    @filters = {
      search: params[:q]&.strip,
      sector: params[:sector],
      location: params[:location]&.strip,
      pro_bono: params[:pro_bono]
    }
    @sector_options = base_scope.where.not(sectors: [nil, []]).pluck(:sectors).flatten.compact.uniq.sort

    scoped = base_scope.order(:full_name)
    if @filters[:sector].present?
      scoped = scoped.where("sectors @> ?", [@filters[:sector]].to_json)
    end
    if @filters[:location].present?
      scoped = scoped.where('LOWER(location) LIKE ?', "%#{@filters[:location].downcase}%")
    end
    if @filters[:pro_bono].present?
      pro_bono_value = @filters[:pro_bono] == 'true'
      scoped = scoped.where(pro_bono: pro_bono_value)
    end
    if @filters[:search].present?
      term = "%#{@filters[:search].downcase}%"
      scoped = scoped.where('LOWER(full_name) LIKE :term OR LOWER(organization) LIKE :term OR LOWER(bio) LIKE :term', term: term)
    end

    @filtered_mentors = scoped
  end

  def pricing
    @static_page = StaticPage.find_by(slug: 'pricing')
  end

  def contact
    @static_page = StaticPage.find_by(slug: 'contact')
  end

  private

  def startup_stage_label(stage)
    STARTUP_STAGE_OPTIONS.find { |option| option[:value] == stage }&.dig(:label) || stage.to_s.titleize
  end

  def funding_stage_label(stage)
    FUNDING_STAGE_LABELS[stage] || stage.to_s.titleize
  end
end