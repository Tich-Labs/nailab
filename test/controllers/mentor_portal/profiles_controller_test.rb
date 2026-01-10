require "test_helper"

module MentorPortal
  class ProfilesControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    setup do
      @user = users(:one)
      # ensure this user has a mentor and profile fixture mapping
      @user.user_profile.update(onboarding_completed: true)
      sign_in @user
    end

    test "updates mentor profile and user_profile fields" do
      patch "/mentor/profile", params: { mentor_profile: { full_name: "Mentor New", bio: "Experienced mentor.", city: "Kigali", country: "Rwanda", professional_website: "https://mentor.example" } }

      assert_redirected_to mentor_profile_path
      @user.reload
      assert_equal "Mentor New", @user.user_profile.full_name
      assert_equal "Kigali", @user.user_profile.city
      assert_equal "Rwanda", @user.user_profile.country
      assert_equal "https://mentor.example", @user.user_profile.professional_website
    end
  end
end
