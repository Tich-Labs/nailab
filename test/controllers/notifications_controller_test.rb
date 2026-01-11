require "test_helper"

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
    # ensure onboarding is completed so ApplicationController doesn't redirect
    profile = @user.user_profile || @user.build_user_profile
    profile.onboarding_completed = true
    profile.role = "founder" unless profile.role.present?
    profile.save!(validate: false)
  end

  test "mark_all_read returns unread_count 0" do
    # create unread notifications
    3.times { Notification.create!(user: @user, title: "T", message: "m") }

    post mark_all_read_notifications_path, xhr: true
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal 0, json["unread_count"]
  end

  test "mark_read marks a single notification read and returns redirect" do
    n = Notification.create!(user: @user, title: "One", message: "m", link: "/")
    post mark_read_notification_path(n), as: :json
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "/", json["redirect"]
    assert n.reload.read?
  end
end
