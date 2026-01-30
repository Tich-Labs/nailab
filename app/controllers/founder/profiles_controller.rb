module Founder
  class ProfilesController < BaseController
    def show
      @user = current_user
      @profile = @user.user_profile
      @startups = @user.startups
    end
  end
end
