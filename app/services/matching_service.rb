class MatchingService
  MATCH_SCORE = {
    sector: 40,
    stage: 25,
    expertise: 30,
    location: 15
  }.freeze

  def initialize(founder_id)
    @founder = User.find_by(id: founder_id)
    raise ActiveRecord::RecordNotFound, "Founder not found" unless @founder
    @founder_profile = @founder.user_profile
    @startup_profile = @founder.startup_profile
    raise ActiveRecord::RecordNotFound, "Founder profile missing" unless @founder_profile
    raise ActiveRecord::RecordNotFound, "Startup profile missing" unless @startup_profile
  end

  def call(limit: 10)
    mentors = mentor_scope
    existing_requests = MentorshipRequest.where(founder_id: @founder.id).pluck(:mentor_id).to_set

    mentors
      .reject { |mentor| existing_requests.include?(mentor.user_id) }
      .map { |mentor| build_match(mentor) }
      .sort_by { |match| -match[:score] }
      .first(limit)
  end

  private

  def mentor_scope
    UserProfile
      .where(role: "mentor", profile_visibility: true, onboarding_completed: true)
      .includes(:user)
  end

  def build_match(mentor_profile)
    location_score = location_match(mentor_profile)
    sector_score = sector_match(mentor_profile)
    stage_score = stage_match(mentor_profile)
    expertise_score = expertise_match(mentor_profile)

    {
      mentor: mentor_payload(mentor_profile),
      score: [ sector_score + stage_score + expertise_score + location_score, 100 ].min.round,
      match_reasons: match_reasons(mentor_profile, sector_score, stage_score, expertise_score, location_score)
    }
  end

  def mentor_payload(mentor_profile)
    {
      id: mentor_profile.user_id,
      profile_id: mentor_profile.id,
      full_name: mentor_profile.full_name,
      bio: mentor_profile.bio,
      title: mentor_profile.title,
      organization: mentor_profile.organization,
      location: mentor_profile.location,
      photo_url: mentor_profile.photo_url,
      linkedin_url: mentor_profile.linkedin_url,
      years_experience: mentor_profile.years_experience,
      advisory_experience: mentor_profile.advisory_experience,
      sectors: mentor_profile.sectors || [],
      expertise: mentor_profile.expertise || [],
      stage_preference: mentor_profile.stage_preference || [],
      availability_hours_month: mentor_profile.availability_hours_month,
      rate_per_hour: mentor_profile.rate_per_hour&.to_f,
      pro_bono: mentor_profile.pro_bono,
      preferred_mentorship_mode: mentor_profile.preferred_mentorship_mode,
      profile_visibility: mentor_profile.profile_visibility,
      onboarding_completed: mentor_profile.onboarding_completed
    }
  end

  def sector_match(mentor_profile)
    return 0 if mentor_profile.sectors.blank? || @startup_profile.sector.blank?
    mentor_profile.sectors.include?(@startup_profile.sector) ? MATCH_SCORE[:sector] : 0
  end

  def stage_match(mentor_profile)
    return 0 if mentor_profile.stage_preference.blank? || @startup_profile.stage.blank?
    mentor_profile.stage_preference.include?(@startup_profile.stage) ? MATCH_SCORE[:stage] : 0
  end

  def expertise_match(mentor_profile)
    return 0 if mentor_profile.expertise.blank? || @startup_profile.mentorship_areas.blank?
    matches = mentor_profile.expertise & @startup_profile.mentorship_areas
    return 0 if matches.empty?
    (matches.length.to_f / [ @startup_profile.mentorship_areas.length, 1 ].max) * MATCH_SCORE[:expertise]
  end

  def location_match(mentor_profile)
    return 0 if mentor_profile.location.blank? || @startup_profile.location.blank?

    mentor_country = mentor_profile.location.split(",").last&.strip
    founder_country = @startup_profile.location.split(",").last&.strip

    return MATCH_SCORE[:location] if mentor_profile.location == @startup_profile.location
    return 10 if mentor_country.present? && mentor_country == founder_country

    regions = {
      east: %w[Kenya Uganda Tanzania Rwanda Burundi],
      west: %w[Nigeria Ghana Senegal Ivory Coast],
      southern: %w[South Africa Zambia Zimbabwe Botswana]
    }

    regions.each_value do |countries|
      return 5 if countries.include?(mentor_country) && countries.include?(founder_country)
    end

    0
  end

  def match_reasons(mentor_profile, sector_score, stage_score, expertise_score, location_score)
    reasons = []
    reasons << "Expert in #{@startup_profile.sector}" if sector_score.positive?

    if stage_score.positive?
      stage_labels = {
        "idea" => "Idea Stage",
        "mvp" => "Early Stage",
        "growth" => "Growth Stage",
        "scale" => "Scaling Stage"
      }
      reasons << "Experienced with #{stage_labels[@startup_profile.stage] || @startup_profile.stage} startups"
    end

    if expertise_score > 15
      matches = mentor_profile.expertise & @startup_profile.mentorship_areas
      reasons << "Can help with #{matches.first(2).join(' and ')}" if matches.any?
    end

    if location_score >= 10
      country = mentor_profile.location.split(",").last&.strip
      reasons << "Based in #{country}" if country.present?
    end

    reasons << "Experienced advisor and investor" if mentor_profile.advisory_experience
    reasons << "Offers pro bono sessions" if mentor_profile.pro_bono
    reasons << "#{mentor_profile.years_experience}+ years of experience" if mentor_profile.years_experience.present?

    reasons.uniq
  end
end
