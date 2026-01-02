class Founder::CommunityController < Founder::BaseController
  def index
    @recommended_peers = User.where.not(id: current_user.id).limit(10) # stub
  end
end
