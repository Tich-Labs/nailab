require "test_helper"

class OnboardingCoreTest < ActiveSupport::TestCase
  test "returns error for unknown role" do
    result = Onboarding::Core.call(actor: nil, role: :unknown, step: "basic", params: {}, session: {})
    assert_not result.success?
    assert_includes result.errors.join, "Unknown role"
  end

  test "delegates to mentors adapter for guest" do
    session = {}
    result = Onboarding::Core.call(actor: nil, role: :mentors, step: "basic_details", params: { full_name: "Jane" }, session: session)
    assert result.success?
    assert_equal "Jane", session[:onboarding_mentors]["full_name"]
  end
end
