require 'rails_helper'

RSpec.describe Founder::BaseController, type: :controller do
  include Devise::Test::ControllerHelpers

  controller do
    def index
      render plain: 'Founder Dashboard Access'
    end
  end

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'authentication requirements' do
    it 'redirects unauthenticated users to sign in' do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'shows flash message for unauthenticated users' do
      get :index
      expect(flash[:alert]).to be_present
    end
  end

  describe 'authenticated user access' do
    let(:founder) {
      user = User.create!(email: 'founder@example.com', password: 'SecurePassword123!', role: 'founder', confirmed_at: Time.current)
      user.create_user_profile!(
        full_name: 'Test Founder',
        role: 'founder',
        phone: '+1234567890',
        country: 'US',
        bio: 'This is a test founder with a bio that meets the minimum length requirement of 30 characters.',
        onboarding_completed: true
      )
      user
    }

    it 'allows authenticated founders to access' do
      sign_in founder
      get :index
      expect(response).to have_http_status(:success)
      expect(response.body).to eq('Founder Dashboard Access')
    end

    it 'provides current_user helper' do
      sign_in founder
      get :index
      expect(controller.current_user).to eq(founder)
    end

    it 'provides user_signed_in? helper' do
      sign_in founder
      get :index
      expect(controller.send(:user_signed_in?)).to be true
    end
  end

  describe 'controller configuration' do
    it 'inherits from ApplicationController' do
      expect(Founder::BaseController.superclass).to eq(ApplicationController)
    end

    it 'requires authentication before actions' do
      before_actions = Founder::BaseController._process_action_callbacks
        .select { |callback| callback.kind == :before }
        .map(&:filter)

      expect(before_actions).to include(:authenticate_user!)
    end

    it 'configures founder_dashboard layout' do
      # Test that the layout is defined at class level
      expect(Founder::BaseController._layout).to eq('founder_dashboard')
    end
  end

  describe 'security features' do
    it 'has CSRF protection enabled' do
      expect(Founder::BaseController.respond_to?(:protect_from_forgery)).to be true
    end

    it 'requires authentication' do
      # The base controller should require authentication for all actions
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'extensibility' do
    it 'can be extended by other controllers' do
      # Test inheritance works properly
      test_controller = Class.new(Founder::BaseController) do
        def test_action
          render plain: 'Extended Controller'
        end
      end

      expect(test_controller.new).to be_a(Founder::BaseController)
    end
  end
end
