require "test_helper"
require "ostruct"

class FounderSidebarRenderTest < ActionController::TestCase
  class DummyController < ApplicationController
    layout "founder_dashboard"
    skip_before_action :redirect_to_onboarding_if_needed
    def index
      render html: "<div></div>".html_safe, layout: "founder_dashboard"
    end

    # Provide a minimal current_user to satisfy view helpers during tests
    def current_user
      @__test_user ||= OpenStruct.new(subscription: nil)
    end
    helper_method :current_user
  end

  tests DummyController

  test "sidebar renders with core links" do
    with_routing do |routes|
      routes.draw { get "test_dummy" => "founder_sidebar_render_test/dummy#index" }
      get :index
    end
    body = @response.body
    assert_includes body, "Startup Profile"
    assert_includes body, "Progress Tracker"
    assert_includes body, "Mentorship"
    assert_includes body, "Resource Library"
    assert_includes body, "Opportunities"
    assert_includes body, "Log Out"
  end
end
