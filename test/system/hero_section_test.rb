require "test_helper"
require "capybara/rails"
require "capybara/minitest"

class HeroSectionTest < ActionDispatch::SystemTestCase
  test "hero section displays slides and has navigation elements" do
    visit root_path

    # Check that hero section is present
    assert_selector "[data-controller='hero']"

    # Check that slides are present (not requiring all to be visible)
    assert_selector "[data-target='hero.slide']", count: 3

    # Check that navigation buttons are present
    assert_selector "[data-action*='hero#previous']"
    assert_selector "[data-action*='hero#next']"

    # Check that dots container exists
    assert_selector "[data-target='hero.dots']", visible: false

    # Basic smoke test - page loads without errors
    assert page.has_css?("[data-controller='hero']")
  end
end
