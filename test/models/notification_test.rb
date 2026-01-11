require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  test "create notification persists and associates with user" do
    user = users(:one)
    n = Notification.create!(user: user, title: "Hello", message: "Test")
    assert n.persisted?
    assert_equal user, n.user
    assert_equal "Hello", n.title
  end
end
require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
