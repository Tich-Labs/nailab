require "test_helper"

class PricingContentTest < ActiveSupport::TestCase
  test "hero merge prefers persisted string-keyed values over defaults" do
    persisted = { "hero" => { "title" => "Custom Title", "subtitle" => "Custom subtitle" } }
    hero = PricingContent.hero(persisted)

    assert_equal "Custom Title", hero[:title]
    assert_equal "Custom subtitle", hero[:subtitle]
  end
end
