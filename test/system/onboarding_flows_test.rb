require "application_system_test_case"

class OnboardingFlowsTest < ApplicationSystemTestCase
  test "founder onboarding flow" do
    visit founder_onboarding_path
    assert_text "Founder Onboarding"
    fill_in "Full name", with: "Test Founder"
    fill_in "Email", with: "founder@example.com"
    fill_in "Phone", with: "0712345678"
    select "Kenya", from: "Country"
    fill_in "City", with: "Nairobi"
    click_on "Save & Continue"
    assert_text "Startup Information"
    # Add more steps as needed
  end

  test "mentor onboarding flow" do
    visit mentor_onboarding_path
    assert_text "Become a Nailab Mentor"
    fill_in "Full name", with: "Test Mentor"
    fill_in "Current role / job title", with: "Mentor"
    fill_in "Short professional bio", with: "Experienced mentor."
    click_on "Save & Continue"
    assert_text "Work & Experience"
    # Add more steps as needed
  end

  test "partner onboarding flow" do
    visit new_partner_onboarding_path
    assert_text "Partner Onboarding"
    fill_in "What is the name of your organization?", with: "Test Org"
    fill_in "What is your organization’s website?", with: "https://test.org"
    fill_in "Which country is your organization headquartered in?", with: "Kenya"
    fill_in "Short description of your organization", with: "A test organization."
    click_on "Save & Continue"
    assert_text "Type of Organization"
    # Add more steps as needed
  end
end
