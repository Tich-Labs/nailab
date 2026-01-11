module Admin::StartupProfilesHelper
  def stage_badge_class(stage)
    s = stage.to_s.downcase
    if s.include?("idea")
      "bg-indigo-100 text-indigo-800 dark:bg-indigo-900 dark:text-indigo-200"
    elsif s.include?("early")
      "bg-amber-100 text-amber-800 dark:bg-amber-900 dark:text-amber-200"
    elsif s.include?("growth")
      "bg-purple-100 text-purple-800 dark:bg-purple-900 dark:text-purple-200"
    elsif s.include?("scal")
      "bg-pink-100 text-pink-800 dark:bg-pink-900 dark:text-pink-200"
    else
      "bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-200"
    end
  end

  def startup_visibility_status(startup)
    if (startup.respond_to?(:active) && startup.active) || (startup.user&.user_profile&.profile_approval_status == "approved")
      "approved"
    elsif startup.respond_to?(:archived) && startup.archived
      "archived"
    else
      "pending"
    end
  end

  def status_badge_class(startup)
    case startup_visibility_status(startup)
    when "approved"
      "bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200"
    when "archived"
      "bg-gray-100 text-gray-700 dark:bg-gray-800 dark:text-gray-200"
    else
      "bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200"
    end
  end

  def message_href_for(startup)
    begin
      new_admin_message_path(user_id: startup.user_id)
    rescue StandardError
      begin
        admin_user_profile_path(startup.user.user_profile)
      rescue StandardError
        "#"
      end
    end
  end

  def public_profile_path_for(startup)
    begin
      startup.try(:rails_admin_preview_path) || public_startup_profile_path(startup)
    rescue StandardError
      "#"
    end
  end
end
