require "ostruct"

class PagesController < ApplicationController
  PROGRAM_CATEGORIES = [
    "Startup Incubation & Acceleration",
    "Masterclasses & Mentorship",
    "Funding Access",
    "Research & Development",
    "Social Impact Programs"
  ].freeze

  RESOURCE_CATEGORY_OPTIONS = [
    { slug: "all", value: "all", label: "All Resources" },
    { slug: "blogs", value: "blog", label: "Blogs" },
    { slug: "knowledge-hub", value: "template", label: "Knowledge Hub" },
    { slug: "opportunities", value: "opportunity", label: "Opportunities" },
    { slug: "events", value: "event", label: "Events & Webinars" }
  ].freeze

  STARTUP_STAGE_OPTIONS = [
    { value: "idea", label: "Idea Stage" },
    { value: "mvp", label: "Early Stage" },
    { value: "growth", label: "Growth Stage" },
    { value: "scale", label: "Scaling Stage" }
  ].freeze

  FUNDING_STAGE_LABELS = {
    "bootstrapped" => "Bootstrapped",
    "friends_family" => "Friends & Family",
    "angel" => "Angel",
    "pre_seed" => "Pre-seed",
    "seed" => "Seed",
    "series_a" => "Series A",
    "series_b_plus" => "Series B+"
  }.freeze

  helper_method :startup_stage_label, :funding_stage_label, :home_content_json
  include PricingPageConcern

  DEFAULT_SUPPORT_ITEMS = [
    {
      title: "Find mentors",
      description: "Book 1-on-1 mentorship sessions and get personalized guidance from seasoned business leaders who've built and scaled successful startups across Africa and beyond.",
      cta_label: "Support",
      cta_link: "/mentors"
    },
    {
      title: "Peer-to-peer network",
      description: "Connect directly with fellow founders who understand your challenges. Share insights, exchange strategies, and build supportive relationships with peers on the same journey.",
      cta_label: "Support",
      cta_link: "/startups"
    },
    {
      title: "Access growth resources",
      description: "Get curated templates, playbooks, funding leads, and exclusive invites to events, pitch days, and accelerator opportunities.",
      cta_label: "Support",
      cta_link: "/resources"
    }
  ].freeze

  DEFAULT_CONNECT_STATS = [
    { value: "1000+", label: "Startups supported" },
    { value: "50+", label: "Partners" },
    { value: "$100M", label: "Funding facilitated" }
  ].freeze

  DEFAULT_CONNECT_CARDS = [
    {
      title: "For Founders",
      description: "Nailab is the launchpad for your bold ideas. Gain access to mentors, collaborate with like-minded founders, and access the tools that help you launch, grow, and scale across Africa.",
      cta_label: "Start your journey with us",
      cta_link: "/founder_onboarding"
    },
    {
      title: "For Mentors",
      description: "Join Nailab’s mentor network to guide promising founders, share expertise, and provide real-world insights that help startups overcome challenges.",
      cta_label: "Become a Mentor",
      cta_link: "/mentor_onboarding"
    },
    {
      title: "For Partners",
      description: "Collaborate with Nailab to co-create programs, support high-potential startups, and drive inclusive innovation with corporates, governments, and funders.",
      cta_label: "Partner with us",
      cta_link: "/partner_onboarding"
    }
  ].freeze

  DEFAULT_CONNECT_INTRO = "Join a thriving community of African founders, mentors, and partners. Share knowledge, access opportunities, and drive innovation together.".freeze

  DEFAULT_BOTTOM_CTA = {
    heading: "Ready to grow your startup?",
    body: "Join Nailab and connect with mentors, programs, and a thriving community of innovators.",
    primary_cta: { label: "Browse Programs", link: "/programs" },
    secondary_cta: { label: "Find a Mentor", link: "/mentors" }
  }.freeze

  def home
    @hero_slides = HeroSlide.where(active: true).order(:display_order)
    @partners = Partner.where(active: true).order(:display_order)
    @logos = Logo.active
    if @logos.blank?
      logos_path = Rails.root.join("app", "assets", "images", "logos")
      if File.directory?(logos_path)
        @asset_logos = Dir.children(logos_path).select { |f| f =~ /\.(png|jpe?g|gif|svg)\z/i }
      else
        @asset_logos = []
      end
    end
    @testimonials = Testimonial.where(active: true).order(:display_order)
    @focus_areas = FocusArea.where(active: true).order(:display_order)
    @program_highlights = Program.where(active: true).order(start_date: :desc).limit(3)
    @resources = Resource.where(active: true).order(published_at: :desc).limit(3)
    @startups = StartupProfile.where(active: true).order(:startup_name).limit(4)
    load_home_content
  end

  def about
  end

  def programs
    @program_categories = PROGRAM_CATEGORIES
    selected_category = params[:category]
    if selected_category.present? && (
         PROGRAM_CATEGORIES.include?(selected_category) ||
         selected_category.include?("Startup Incubation") ||
         selected_category.include?("Startup Acceleration")
       )
      # Map 'Social Impact Programs' to 'Social Impact' for filtering
      mapped_category = selected_category == "Social Impact Programs" ? "Social Impact" : selected_category
      if mapped_category == "Startup Incubation & Acceleration"
        @programs = Program.where(active: true)
          .where("category ILIKE ? OR category ILIKE ? OR program_type = ?",
            "%Startup Incubation%", "%Startup Acceleration%", "incubation_acceleration")
      else
        @programs = Program.where(active: true)
          .where("category = ? OR program_type = ?", mapped_category, mapped_category.parameterize.underscore)
      end
    else
      @programs = Program.where(active: true)
    end
    @programs = @programs.order(start_date: :desc)
  end

  def program_detail
    @program = Program.find_by(slug: params[:slug], active: true)
    redirect_to programs_path, alert: "Program not found" if @program.nil?
  end

  def resources
    @resource_categories = RESOURCE_CATEGORY_OPTIONS
    incoming_category = params[:category].presence
    selected_option = RESOURCE_CATEGORY_OPTIONS.find { |option| option[:slug] == incoming_category }
    selected_option ||= RESOURCE_CATEGORY_OPTIONS.find { |option| option[:value] == incoming_category }
    @selected_category = selected_option ? selected_option[:slug] : "all"
    search_term = params[:q]&.strip
    base_scope = Resource.where(active: true)
    filtered_value = selected_option.present? ? selected_option[:value] : "all"
    scoped = if filtered_value == "all"
      base_scope
    else
      base_scope.where(resource_type: filtered_value)
    end
    @search_query = search_term
    @resources = if search_term.present?
      term = "%#{search_term.downcase}%"
      scoped.where("LOWER(title) LIKE ? OR LOWER(description) LIKE ?", term, term)
    else
      scoped
    end.order(published_at: :desc)
  end

  def resource_detail
    active_resources = Resource.where(active: true)
    @resource = active_resources.detect { |resource| resource.slug == params[:slug] }
    return redirect_to resources_path, alert: "Resource not found" if @resource.nil?

    category_option = RESOURCE_CATEGORY_OPTIONS.find { |option| option[:value] == @resource.resource_type }
    @resource_category_slug = category_option ? category_option[:slug] : "all"
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
    @sector_options = base_scope.where.not(sector: [ nil, "" ]).distinct.order(:sector).pluck(:sector)
    @stage_options = STARTUP_STAGE_OPTIONS

    scoped = base_scope.order(:startup_name)
    if @filters[:sector].present?
      scoped = scoped.where(sector: @filters[:sector])
    end
    if @filters[:stage].present?
      scoped = scoped.where(stage: @filters[:stage])
    end
    if @filters[:location].present?
      scoped = scoped.where("LOWER(location) LIKE ?", "%#{@filters[:location].downcase}%")
    end
    if @filters[:search].present?
      term = "%#{@filters[:search].downcase}%"
      scoped = scoped.where("LOWER(startup_name) LIKE :term OR LOWER(description) LIKE :term OR LOWER(sector) LIKE :term", term: term)
    end

    @filtered_startups = scoped
  end

  def startup_profile
    @startup_profile = StartupProfile.includes(user: :user_profile).find_by(id: params[:id]) ||
                       StartupProfile.includes(user: :user_profile).find_by(slug: params[:id])
    @owner_viewing = owner_signed_in?
    redirect_to startups_path, alert: "This profile is private." unless @startup_profile.public_viewable? || @owner_viewing
  end

  def mentor_directory
    base_scope = UserProfile.where(role: "mentor", profile_visibility: true)
    @filters = {
      search: params[:q]&.strip,
      sector: params[:sector],
      location: params[:location]&.strip,
      pro_bono: params[:pro_bono]
    }
    @sector_options = base_scope.where.not(sectors: [ nil, [] ]).pluck(:sectors).flatten.compact.uniq.sort

    scoped = base_scope.order(:full_name)
    if @filters[:sector].present?
      scoped = scoped.where("sectors @> ?", [ @filters[:sector] ].to_json)
    end
    if @filters[:location].present?
      scoped = scoped.where("LOWER(location) LIKE ?", "%#{@filters[:location].downcase}%")
    end
    if @filters[:pro_bono].present?
      pro_bono_value = @filters[:pro_bono] == "true"
      scoped = scoped.where(pro_bono: pro_bono_value)
    end
    if @filters[:search].present?
      term = "%#{@filters[:search].downcase}%"
      scoped = scoped.where("LOWER(full_name) LIKE :term OR LOWER(organization) LIKE :term OR LOWER(bio) LIKE :term", term: term)
    end

    @filtered_mentors = scoped
  end

  def pricing
    load_pricing_content
  end

  def contact
    load_contact_content
  end

  def home_content_json
    @home_content_json
  end

  def load_contact_content
    @contact_page = ContactPage.first || ContactPage.new(title: "Contact Us")
    @contact_content = parse_contact_structured_content(@contact_page.content)
    default_faqs = [
      {
        question: "1. What kind of startups does Nailab support?",
        answer: "Nailab supports early-stage and growth-stage startups leveraging innovation to tackle Africa’s most pressing social challenges across key sectors including fintech, agritech, healthtech, edtech, SaaS, cleantech, creative & mediatech, e-commerce & retailtech, mobility & logisticstech, and social impact. We partner with passionate founders with a clear vision and deep understanding of the challenges they are addressing."
      },
      {
        question: "2. How do I apply for Nailab’s programs?",
        answer: "Interested in joining a Nailab program? We regularly announce application windows on our official website and social media platforms. You can find detailed information and application links for all our current opportunities on our Programs page."
      },
      {
        question: "3. What does a typical incubation and/or accelerator program involve?",
        answer: "Our programs typically run for 3–6 months, depending on the specific focus and structure. They are designed to equip entrepreneurs with the tools, knowledge, and networks they need to build and scale sustainable businesses. Key components include mentorship, business development training, pitch coaching, access to investors, and seed funding where applicable."
      },
      {
        question: "4. What stage should my startup be at to apply for Nailab Programs?",
        answer: "While some programs are tailored for early-stage entrepreneurs, others suit startups with a developed product and initial traction. Review eligibility in each program call for details."
      },
      {
        question: "5. Does Nailab provide funding to startups?",
        answer: "Yes. Some programs provide seed funding or connect startups to investors through demo days and pitch sessions."
      },
      {
        question: "6. What are the benefits of joining the Nailab startup network?",
        answer: "Access a thriving community of founders, expert mentors, and ecosystem partners, plus tools, templates, and curated resources to help you build and grow."
      },
      {
        question: "7. How can I become a Nailab mentor?",
        answer: "We’re always looking for experienced mentors. Visit our Mentors page to learn more and apply."
      },
      {
        question: "8. How can I partner with Nailab?",
        answer: "We collaborate with agencies, corporates, governments, and academia to co-create programs and support startups. Reach out via our Expertise page."
      }
    ]

    @faqs = if @contact_content[:faqs].is_a?(Array) && @contact_content[:faqs].any?
      @contact_content[:faqs].map { |f| f.is_a?(Hash) ? f.with_indifferent_access : {} }
    else
      default_faqs.map(&:with_indifferent_access)
    end

    @faqs = @faqs.first(8)
    @faqs << {} while @faqs.size < 8
  end

  def parse_contact_structured_content(content)
    return {} unless content.present?
    parsed = JSON.parse(content) rescue {}
    parsed.is_a?(Hash) ? parsed.with_indifferent_access : {}
  end
  #
  # def load_pricing_content
  #   @pricing_page = PricingPage.first || PricingPage.new(title: "Pricing")
  #   @structured_content = parse_pricing_structured_content(@pricing_page.content)
  #   @pricing_tiers = PricingContent.tiers(@structured_content)
  #   @pricing_hero = PricingContent.hero(@structured_content)
  # end

  private

  def owner_signed_in?
    current_user.present? && current_user.id == @startup_profile.user_id
  end

  def startup_stage_label(stage)
    STARTUP_STAGE_OPTIONS.find { |option| option[:value] == stage }&.dig(:label) || stage.to_s.titleize
  end

  def funding_stage_label(stage)
    FUNDING_STAGE_LABELS[stage] || stage.to_s.titleize
  end

  def load_home_content
    homepage = HomePage.first
    raw_structured = homepage&.structured_content || {}
    @home_content_json = case raw_structured
    when Hash
      raw_structured.with_indifferent_access
    when String
      begin
        parsed = JSON.parse(raw_structured)
        parsed.is_a?(Hash) ? parsed.with_indifferent_access : {}
      rescue JSON::ParserError
        {}
      end
    when NilClass
      {}
    else
      Rails.logger.warn("Unexpected type for structured_content: \\#{raw_structured.class}")
      {}
    end.with_indifferent_access

    hero_json = (@home_content_json[:hero].is_a?(Hash) ? @home_content_json[:hero] : {}).with_indifferent_access
    json_slides = hero_slides_from_json(hero_json)
    @hero_slides = json_slides.presence || @hero_slides
    @hero_badge = hero_json[:badge].presence || "Startup growth, made in Africa"
    @hero_secondary_cta = (hero_json[:secondary_cta].is_a?(Hash) ? hero_json[:secondary_cta] : default_hero_secondary_cta).with_indifferent_access
    @who_we_are_content = (@home_content_json[:who_we_are].is_a?(Hash) ? @home_content_json[:who_we_are] : {}).with_indifferent_access
    @how_we_support_items = (@home_content_json[:how_we_support].is_a?(Array) ? @home_content_json[:how_we_support] : DEFAULT_SUPPORT_ITEMS).map { |item| item.is_a?(Hash) ? item.with_indifferent_access : {} }
    connect_json = (@home_content_json[:connect_grow_impact].is_a?(Hash) ? @home_content_json[:connect_grow_impact] : {}).with_indifferent_access
    @connect_intro = connect_json[:intro].presence || DEFAULT_CONNECT_INTRO
    @connect_stats = connect_json[:stats].presence || DEFAULT_CONNECT_STATS
    @connect_title = connect_json[:title].presence || "Connect. Grow. Impact."
    @connect_cards = connect_json[:cards].is_a?(Array) ? connect_json[:cards].map { |card| card.is_a?(Hash) ? card.with_indifferent_access : {} } : DEFAULT_CONNECT_CARDS
    bottom_cta_json = (@home_content_json[:bottom_cta].is_a?(Hash) ? @home_content_json[:bottom_cta] : {}).with_indifferent_access
    @bottom_cta_content = DEFAULT_BOTTOM_CTA.deep_dup
    @bottom_cta_content.deep_merge!(bottom_cta_json)
    @bottom_cta_content = @bottom_cta_content.with_indifferent_access
    @home_content_json
  end

  def hero_slides_from_json(hero_json)
    return unless hero_json.present?
    slides = hero_json[:slides].presence || hero_json[:slide].presence
    if slides.blank?
      single = hero_json.slice(:title, :subtitle, :image_url, :cta_text, :cta_link)
      slides = [ single ] if single[:title].present?
    end
    return unless slides.present?
    slides.map { |attrs| OpenStruct.new(attrs) }
  end

  def default_hero_secondary_cta
    { "label" => "Find a mentor", "link" => "/mentors" }
  end
end
