require "test_helper"

class FounderAuthenticationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    # These tests assume you have fixtures for a confirmed founder and a confirmed mentor.
    # e.g., in users.yml and user_profiles.yml
    @founder = users(:founder_user)
    @mentor = users(:mentor_user)

    # Ensure user profiles exist for testing.
    @founder.create_user_profile(role: "founder") unless @founder.user_profile
    @mentor.create_user_profile(role: "mentor") unless @mentor.user_profile
  end

  test "unauthenticated user is redirected from founder dashboard" do
    get founder_root_path
    assert_redirected_to new_user_session_path
    assert_equal "Please sign in to access this page.", flash[:alert]
  end

  test "founder can sign in and is redirected to onboarding if not completed" do
    @founder.user_profile.update_column(:onboarding_completed, false)

    post user_session_path, params: {
      user: { email: @founder.email, password: "password12345" } # Use a valid password
    }

    assert_equal "Signed in successfully.", flash[:notice]

    # The `redirect_to_onboarding_if_needed` before_action should trigger
    assert_redirected_to founder_onboarding_path
  end

  test "onboarded founder can sign in and is redirected to dashboard" do
    @founder.user_profile.update_column(:onboarding_completed, true)

    post user_session_path, params: {
      user: { email: @founder.email, password: "password12345" } # Use a valid password
    }

    assert_equal "Signed in successfully.", flash[:notice]
    assert_redirected_to founder_root_path

    follow_redirect!
    assert_response :success
    assert_select "h2", text: /Welcome/i # Check for content on the founder dashboard
  end

  test "mentor cannot access founder dashboard" do
    sign_in @mentor
    get founder_root_path
    assert_redirected_to root_path
    assert_equal "Access denied.", flash[:alert]
  end

  test "founder can sign up and is asked to wait for approval" do
    assert_difference("User.count", 1) do
      post user_registration_path, params: {
        user: {
          email: "new.founder@example.com",
          password: "password12345",
          password_confirmation: "password12345",
          role: "founder"
        }
      }
    end

    assert_equal "Thanks for signing up. We'll review your application and send an approval email shortly.", flash[:notice]
    assert_redirected_to root_path

    new_user = User.find_by(email: "new.founder@example.com")
    assert new_user
    assert_not new_user.confirmed?, "New founder should not be confirmed immediately"
  end
end
