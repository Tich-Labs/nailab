require "test_helper"

class AfterSignInPathForTest < ActionController::TestCase
  class DummyController < ApplicationController
    skip_before_action :redirect_to_onboarding_if_needed
    def call_path
      user = User.find(params[:user_id]) if params[:user_id].present?
      render plain: after_sign_in_path_for(user)
    end
  end

  tests DummyController

  test "after_sign_in merges onboarding session and redirects mentor to mentor root" do
    session[:onboarding_mentors] = { "full_name" => "Merge Mentor", "phone" => "+254700000001" }

    user = User.create!(email: "merge-mentor@example.com", password: "password123")

    with_routing do |routes|
      routes.draw { get "test_dummy/:user_id" => "after_sign_in_path_for_test/dummy#call_path" }
      get :call_path, params: { user_id: user.id }
    end

    assert_nil session[:onboarding_mentors]
    assert_equal mentor_root_path, @response.body
  end

  test "after_sign_in merges onboarding session and redirects founder to founder root" do
    session[:onboarding_founders] = { "full_name" => "Founding Fred", "startup_name" => "Foundry" }

    user = User.create!(email: "merge-founder@example.com", password: "password123")

    with_routing do |routes|
      routes.draw { get "test_dummy/:user_id" => "after_sign_in_path_for_test/dummy#call_path" }
      get :call_path, params: { user_id: user.id }
    end

    assert_nil session[:onboarding_founders]
    assert_equal founder_root_path, @response.body
  end
end
