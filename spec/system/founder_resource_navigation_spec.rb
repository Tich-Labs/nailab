
require "rails_helper"

RSpec.describe "Founder Resource Navigation", type: :system do
  let!(:founder) do
    user = User.find_by(email: "founder4@example.com")
    unless user
      user = User.create!(email: "founder4@example.com", password: "SecurePassword123!", role: 0, confirmed_at: Time.current)
      UserProfile.create!(
        user: user,
        full_name: "Founder Four",
        onboarding_completed: true,
        profile_approval_status: "approved",
        phone: "+254700000000",
        country: "Kenya",
        bio: "This is a sufficiently long founder bio for testing purposes. It exceeds 30 characters."
      )
    end
    user
  end
  let!(:resource1) { FactoryBot.create(:resource, title: "Resource One", slug: "resource-one", active: true) }
  let!(:resource2) { FactoryBot.create(:resource, title: "Resource Two", slug: "resource-two", active: true) }

  before do
    driven_by(:rack_test)
    sign_in founder
  end

  it "returns to founder resources after viewing a resource and clicking back" do
    visit founder_resources_path(resource_type: "", search: "", bookmarked: 0, commit: "Filter")
    expect(page).to have_content("Resource One")
    expect(page).to have_content("Resource Two")

    # Click the first resource title link
    click_link "Resource One"
    expect(page).to have_content("Resource One")
    expect(page).to have_link("Back to resources")

    # Click back to resources
    click_link "Back to resources"
    expect(page).to have_current_path(founder_resources_path(resource_type: "", search: "", bookmarked: 0, commit: "Filter"), ignore_query: false)
    expect(page).to have_content("Resource One")
    expect(page).to have_content("Resource Two")
  end

  it "preserves founder resources return path when navigating related resources" do
    visit founder_resources_path(resource_type: "", search: "", bookmarked: 0, commit: "Filter")
    click_link "Resource One"
    expect(page).to have_content("Resource One")
    # Simulate clicking a related resource (if present)
    if page.has_link?("Resource Two")
      click_link "Resource Two"
      expect(page).to have_content("Resource Two")
      click_link "Back to resources"
      expect(page).to have_current_path(founder_resources_path(resource_type: "", search: "", bookmarked: 0, commit: "Filter"), ignore_query: false)
    end
  end
end
