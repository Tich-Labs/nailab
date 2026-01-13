class Founder::CommunityController < Founder::BaseController
  def index
    @recommended_peers = User.where.not(id: current_user.id).where(role: "founder", admin: false).limit(10)
  end

  # Admin action: remove startup profiles that appear empty.
  # Criteria: description and value_proposition are blank (nil or empty string).
  def cleanup_empty_profiles
    unless current_user.admin?
      return redirect_to founder_community_path, alert: "Not authorized"
    end

    empties = StartupProfile.where("COALESCE(description,'') = '' AND COALESCE(value_proposition,'') = ''")
    deleted_ids = empties.pluck(:id)
    count = empties.destroy_all.size
    Notification.create!(user: current_user, title: "Cleanup completed", message: "Deleted #{count} empty startup profiles (your subscription: #{current_user.subscription&.tier || 'free'})", link: pricing_path, metadata: { admin_subscription: current_user.subscription&.tier }) rescue nil
    redirect_to founder_community_path, notice: "Deleted #{count} empty startup profiles (ids: #{deleted_ids.join(', ')})"
  end
end
