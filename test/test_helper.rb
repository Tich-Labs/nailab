ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "capybara/rails"
require "capybara/minitest"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup fixtures for tests. Limit to only required fixtures to avoid
    # loading fixtures whose columns may not match the current schema.
    fixtures :users

    # Add more helper methods to be used by all tests here...
  end
end

# Configure Capybara for system testing
Capybara.configure do |config|
  config.default_driver = :selenium_chrome_headless
  config.javascript_driver = :selenium_chrome_headless
  config.default_max_wait_time = 10
  config.server = :puma, { Silent: true }
end

# Register different viewport sizes for responsive testing
Capybara.register_driver :mobile do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu window-size=375,667]))
end

Capybara.register_driver :tablet do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu window-size=768,1024]))
end

Capybara.register_driver :desktop do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu window-size=1920,1080]))
end

# Provide test-friendly no-op stubs for notifier/jobs used by onboarding flows
module Notifications
  unless const_defined?(:OnboardingNotifier)
    class OnboardingNotifier
      def self.notify_user_on_completion(user:, role:, payload: {}); end
      def self.notify_admin_of_submission(user:, role:, payload: {}); end
    end
  end
end

module Jobs
  unless const_defined?(:SendWelcomeEmailJob)
    class SendWelcomeEmailJob
      def self.perform_later(*_args); end
    end
  end
end
