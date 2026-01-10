require "test_helper"

class Founder::AccountControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @user.user_profile.update(onboarding_completed: true)
    sign_in @user
  end

  test "updates user profile fields from account edit" do
    patch founder_account_path, params: { user: { email: @user.email, user_profile: { full_name: "New Name", bio: "Short bio about user.", city: "Nairobi", country: "Kenya", professional_website: "https://example.com" } } }

    assert_redirected_to founder_account_path
    @user.reload
    assert_equal "New Name", @user.user_profile.full_name
    assert_equal "Nairobi", @user.user_profile.city
    assert_equal "Kenya", @user.user_profile.country
    assert_equal "https://example.com", @user.user_profile.professional_website
  end
end
