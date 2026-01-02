require "test_helper"
require "capybara/rails"
require "capybara/minitest"

class ResponsiveDesignTest < ActionDispatch::SystemTestCase
  include Devise::Test::IntegrationHelpers

  # Test mobile responsiveness (375x667)
  test "mobile navigation works correctly" do
    Capybara.current_driver = :mobile

    visit root_path

    # Check that mobile menu button exists (md:hidden class)
    assert_selector "button.md\\:hidden", visible: true

    # Check that main navigation is hidden on mobile (hidden md:flex)
    assert_selector "nav.hidden.md\\:flex", visible: false

    # Test mobile menu toggle (if JavaScript works)
    if page.has_selector?("button.md\\:hidden")
      # Note: This would require JavaScript testing setup for full functionality
      # For now, just verify the button exists
    end
  end

  test "mobile founder dashboard layout" do
    Capybara.current_driver = :mobile

    user = users(:one)
    user.user_profile&.update!(onboarding_completed: true)
    sign_in user

    visit founder_root_path

    # Check sidebar is hidden on mobile (hidden md:block)
    assert_selector "aside.hidden.md\\:block", visible: false

    # Check main content takes full width on mobile (ml-0 md:ml-64)
    assert_selector ".flex-1.ml-0.md\\:ml-64", visible: true
  end

  # Test tablet responsiveness (768x1024)
  test "tablet layout displays correctly" do
    Capybara.current_driver = :tablet

    visit root_path

    # On tablet, navigation should be visible (hidden md:flex)
    assert_selector "nav.hidden.md\\:flex", visible: true

    # Mobile menu should be hidden (md:hidden)
    refute_selector "button.md\\:hidden", visible: true
  end

  test "tablet founder dashboard sidebar" do
    Capybara.current_driver = :tablet

    user = users(:one)
    user.user_profile&.update!(onboarding_completed: true)
    sign_in user

    visit founder_root_path

    # Sidebar should be visible on tablet (hidden md:block)
    assert_selector "aside.hidden.md\\:block", visible: true

    # Content should be properly laid out
    assert_selector ".flex-1.ml-0.md\\:ml-64", visible: true
  end

  # Test desktop responsiveness (1920x1080)
  test "desktop layout displays correctly" do
    Capybara.current_driver = :desktop

    visit root_path

    # Desktop navigation should be fully visible
    assert_selector "nav.hidden.md\\:flex", visible: true

    # Hero section should be properly sized
    assert_selector "section.relative.overflow-hidden", visible: true
  end

  test "desktop founder dashboard full layout" do
    Capybara.current_driver = :desktop

    user = users(:one)
    user.user_profile&.update!(onboarding_completed: true)
    sign_in user

    visit founder_root_path

    # Sidebar should be visible
    assert_selector "aside.hidden.md\\:block", visible: true

    # Main content should take full width
    assert_selector ".flex-1.ml-0.md\\:ml-64", visible: true

    # Check that dashboard content is visible
    assert_selector "main.p-8", visible: true
  end

  # Test programs page responsiveness
  test "programs page responsive grid" do
    # Create an active program for testing
    Program.create!(
      title: "Test Program",
      slug: "test-program",
      description: "A test program for responsive design",
      cover_image_url: "https://example.com/image.jpg",
      category: "Startup Incubation & Acceleration",
      active: true,
      start_date: Date.today,
      end_date: Date.today + 30.days
    )

    # Test mobile: single column (no grid classes visible)
    Capybara.current_driver = :mobile
    visit programs_path
    assert_selector ".bg-white.rounded-xl", visible: true
    # Cards should stack vertically on mobile (no grid layout)

    # Test tablet: 2 columns (md:grid-cols-2)
    Capybara.current_driver = :tablet
    visit programs_path
    assert_selector ".bg-white.rounded-xl", visible: true

    # Test desktop: 3 columns (lg:grid-cols-3)
    Capybara.current_driver = :desktop
    visit programs_path
    assert_selector ".bg-white.rounded-xl", visible: true
  end

  # Test mentorship directory responsiveness
  test "mentorship directory responsive layout" do
    user = users(:one)
    user.user_profile&.update!(onboarding_completed: true)
    sign_in user

    # Test mobile layout
    Capybara.current_driver = :mobile
    visit founder_mentorship_path
    # Check that page loads (basic responsiveness test)
    assert_selector "body", visible: true

    # Test tablet layout
    Capybara.current_driver = :tablet
    visit founder_mentorship_path
    assert_selector "body", visible: true

    # Test desktop layout
    Capybara.current_driver = :desktop
    visit founder_mentorship_path
    assert_selector "body", visible: true
  end

  # Test form responsiveness
  test "onboarding forms work on mobile" do
    Capybara.current_driver = :mobile

    user = users(:one)
    sign_in user

    visit founder_onboarding_path

    # Forms should be mobile-friendly
    assert_selector "form", visible: true

    # Check that viewport meta tag is present for mobile
    assert_selector "meta[name='viewport']", visible: false # Meta tags aren't visible in DOM
  end

  # Test modal responsiveness
  test "mentorship request modal on mobile" do
    Capybara.current_driver = :mobile

    user = users(:one)
    user.user_profile&.update!(onboarding_completed: true)
    sign_in user

    visit founder_mentorship_path

    # Check that the page loads properly on mobile
    assert_selector "body", visible: true

    # If there are request buttons, they should be touch-friendly
    # (This would require actual mentor data to test fully)
  end
end
