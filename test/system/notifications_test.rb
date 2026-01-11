require "application_system_test_case"

class NotificationsSystemTest < ApplicationSystemTestCase
  test "real-time notification updates badge" do
    user = users(:one)

    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_button "Log in"

    visit founder_root_path

    # Initially there should be no notifications badge
    assert_no_selector "#notifications-count"

    # Create a notification for the signed-in user; model broadcasts after_create
    Notification.create!(user: user, title: "Test Notification", message: "Hello from test")

    # Browser should receive the ActionCable broadcast and update the badge
    assert_selector "#notifications-count", text: "1", wait: 5
  end
end
