require "application_system_test_case"

class ProgramsFilteringTest < ApplicationSystemTestCase
  setup do
    driven_by :selenium_chrome_headless
    @cat1 = Category.create!(name: "Startup Incubation & Acceleration")
    @cat2 = Category.create!(name: "Masterclasses & Mentorship")

    @p1 = Program.create!(title: "Incubate 1", slug: "incubate-1", active: true, short_summary: "Incubation program", cover_image_url: "", video_url: "")
    @p2 = Program.create!(title: "Masterclass 1", slug: "masterclass-1", active: true, short_summary: "Masterclass program", cover_image_url: "", video_url: "")

    @p1.categories << @cat1
    @p2.categories << @cat2
  end

  test "filtering via click and keyboard updates list and aria live" do
    visit programs_path

    # Ensure both program cards present initially
    assert_selector ".program-card", count: 2

    # Click Masterclasses filter
    within '[data-program-filter-target="list"]' do
      click_on "Masterclasses & Mentorship"
    end

    # Program list should update to show only one
    assert_selector ".program-card", count: 1

    # ARIA live region should announce count
    assert_text /1 program/, within: "#programs-status"

    # Keyboard navigation: focus first filter, move right and activate via Enter
    find('[data-program-filter-target="list"]').find("a", match: :first).send_keys(:arrow_right)
    find('a[aria-pressed="true"]', match: :first)
  end
end
