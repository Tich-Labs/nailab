require "test_helper"

class UserProfileTest < ActiveSupport::TestCase
  test "approve and reject change status and send mail" do
    user = users(:one) rescue User.first || User.create!(email: "test@example.com", password: "Password1!")
    profile = user.user_profile || user.create_user_profile!(full_name: "T Tester", phone: "123", country: "US", bio: "a" * 30)

    # Clear deliveries
    ActionMailer::Base.deliveries.clear

    profile.approve!(actor: nil)
    assert profile.reload.approved?
    assert_equal 1, ActionMailer::Base.deliveries.size

    profile.reject!(reason: "Not good", actor: nil)
    assert profile.reload.rejected?
    assert_equal 2, ActionMailer::Base.deliveries.size
  end
end
require "test_helper"

class UserProfileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
