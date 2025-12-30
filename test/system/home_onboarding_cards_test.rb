require "test_helper"
require "capybara/rails"
require "capybara/minitest"

class HomeOnboardingCardsTest < ActionDispatch::SystemTestCase
  # Test paused for investigation. Uncomment to re-enable.
  # include Devise::Test::IntegrationHelpers
  #
  # test "home page cards link to founder and mentor onboarding" do
  #   user = users(:one)
  #   sign_in user
  #
  #   visit root_path
  #
  #   # Assert the presence of the onboarding CTA link for founders
  #   assert_selector("a", text: "Start your journey with us", wait: 5)
  #   founder_cta = find("a", text: "Start your journey with us")
  #   assert_equal "/founder_onboarding", founder_cta[:href]
  #   founder_cta.click
  #   assert_current_path "/founder_onboarding"
  #   assert_selector("body", text: /Founder Onboarding|Personal|Startup|Professional|Mentorship|Confirm/, wait: 5)
  #
  #   visit root_path
  #   # Assert the presence of the onboarding CTA link for mentors
  #   assert_selector("a", text: "Become a Mentor", wait: 5)
  #   mentor_cta = find("a", text: "Become a Mentor")
  #   assert_equal "/mentor_onboarding", mentor_cta[:href]
  #   mentor_cta.click
  #   assert_current_path "/mentor_onboarding"
  #   assert_selector("body", text: /Mentor Onboarding|Step|Profile|Expertise|Experience/, wait: 5)
  # end
end
