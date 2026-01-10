module DashboardHelper
  # Estimate profile completion percentage based on presence of key fields
  def profile_completion_percent(user)
    return 0 unless user

    up = user.user_profile || OpenStruct.new
    sp = user.startup_profile || OpenStruct.new

    user_keys = %w[full_name phone country city email]
    startup_keys = %w[startup_name sector stage description website_url]

    total = user_keys.size + startup_keys.size
    present = 0

    user_keys.each do |k|
      present += 1 if up.respond_to?(k) && up.public_send(k).present?
    end

    startup_keys.each do |k|
      present += 1 if sp.respond_to?(k) && sp.public_send(k).present?
    end

    ((present.to_f / total) * 100).round
  end

  # Map percent to approximate steps left (20% per step)
  def profile_steps_left(user)
    percent = profile_completion_percent(user)
    remaining = [ 100 - percent, 0 ].max
    [ ((remaining / 20.0).ceil), 0 ].max
  end

  # Determine the onboarding path for a user by role
  def next_onboarding_path_for(user)
    profile = user.respond_to?(:user_profile) ? user.user_profile : nil
    role = profile&.role.to_s
    case role
    when "mentor"
      respond_to?(:mentor_onboarding_path) ? mentor_onboarding_path : founder_onboarding_path
    when "partner"
      respond_to?(:partner_onboarding_path) ? partner_onboarding_path : founder_onboarding_path
    else
      founder_onboarding_path
    end
  end
end
