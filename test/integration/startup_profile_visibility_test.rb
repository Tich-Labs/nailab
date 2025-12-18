require "test_helper"

class StartupProfileVisibilityTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @startup_profile = startup_profiles(:one)
    @user.user_profile&.update!(onboarding_completed: true)
    @startup_profile.update!(
      startup_name: "LaunchPad",
      description: "Product-market fit is our focus",
      stage: "MVP",
      sector: "Fintech",
      target_market: "SMBs in East Africa",
      value_proposition: "Faster payouts for mobile merchants",
      funding_stage: "Seed",
      website_url: "https://nailab.africa",
      profile_visibility: false
    )
    sign_in @user
  end

  test "founders can toggle visibility through edit form" do
    patch founder_startup_profile_path, params: {
      startup_profile: {
        profile_visibility: "1"
      }
    }

    assert_redirected_to founder_startup_profile_path
    assert_equal "Profile updated successfully.", flash[:notice]
    assert @startup_profile.reload.profile_visibility?
  end

  test "non-owners cannot view private startup profiles" do
    @startup_profile.update!(profile_visibility: false)
    sign_out @user

    get public_startup_profile_path(@startup_profile)

    assert_redirected_to startups_path
    assert_equal "This profile is private.", flash[:alert]
  end

  test "founders can view their private profile" do
    @startup_profile.update!(profile_visibility: false)

    get founder_startup_profile_path

    assert_response :success
    assert_nil flash[:alert]
    assert_nil flash[:notice]
  end
end
