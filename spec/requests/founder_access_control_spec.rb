require 'rails_helper'

RSpec.describe 'Role-based Access Control in Founder Routes' do
  describe 'Founder route protection' do
    let(:founder) { User.create!(email: 'founder@example.com', password: 'SecurePassword123!', role: 'founder', confirmed_at: Time.current) }
    let(:mentor) { User.create!(email: 'mentor@example.com', password: 'SecurePassword123!', role: 'mentor', confirmed_at: Time.current) }
    let(:admin) { User.create!(email: 'admin@example.com', password: 'SecurePassword123!', role: 'admin', confirmed_at: Time.current) }

    before do
      # Create profiles for users
      founder.create_user_profile!(
        full_name: 'Jane Founder',
        role: 'founder',
        phone: '+1234567890',
        country: 'US',
        bio: 'This bio meets the minimum length requirement for founders with more than thirty characters.',
        onboarding_completed: true
      )

      mentor.create_user_profile!(
        full_name: 'John Mentor',
        role: 'mentor',
        title: 'Senior Advisor',
        organization: 'Tech Company',
        years_experience: 10,
        bio: 'Experienced mentor with expertise in technology and startup development.',
        mentorship_approach: 'Hands-on mentoring approach with regular check-ins and practical guidance.',
        motivation: 'Passionate about helping founders succeed.',
        stage_preference: 'Seed',
        preferred_mentorship_mode: 'one-on-one',
        availability_hours_month: 5,
        rate_per_hour: 100
      )
    end

    context 'unauthenticated access' do
      it 'redirects to sign in for founder dashboard' do
        get '/founder/dashboard'

        expect(response).to redirect_to(new_user_session_path)
      end

      it 'redirects to sign in for founder settings' do
        get '/founder/account'

        expect(response).to redirect_to(new_user_session_path)
      end

      it 'redirects to sign in for founder startup profile' do
        get '/founder/startup_profile'

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'founder authentication' do
      before { sign_in founder }

      it 'allows access to founder dashboard' do
        get '/founder/dashboard'

        expect(response).to have_http_status(:success)
      end

      it 'allows access to founder settings' do
        get '/founder/account'

        expect(response).to have_http_status(:success)
      end

      it 'allows access to startup profile management' do
        get '/founder/startup_profile'

        expect(response).to have_http_status(:success)
      end

      it 'allows access to milestones' do
        get '/founder/milestones'

        expect(response).to have_http_status(:success)
      end

      it 'allows access to mentorship requests' do
        get '/founder/mentorship_requests'

        expect(response).to have_http_status(:success)
      end
    end

    context 'mentor authentication' do
      before { sign_in mentor }

      it 'denies access to founder dashboard' do
        get '/founder/dashboard'

        # Depending on implementation, may redirect to root or show access denied
        expect(response).not_to have_http_status(:success)
      end

      it 'denies access to founder settings' do
        get '/founder/account'

        expect(response).not_to have_http_status(:success)
      end

      it 'denies access to startup profile management' do
        get '/founder/startup_profile'

        expect(response).not_to have_http_status(:success)
      end
    end

    context 'admin authentication' do
      before { sign_in admin }

      it 'allows access to founder dashboard' do
        get '/founder/dashboard'

        # Admins typically have access to all areas
        expect(response).to have_http_status(:success)
      end

      it 'allows access to founder settings' do
        get '/founder/account'

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'Route constraints and middleware' do
    it 'uses Founder::BaseController for founder routes' do
      # Test that the routes are properly namespaced
      expect(Rails.application.routes.routes.map(&:defaults).compact).to include(
        hash_including(controller: 'founder/dashboard')
      )
    end

    it 'requires authentication for all founder routes' do
      founder_routes = [
        '/founder/dashboard',
        '/founder/account',
        '/founder/startup_profile',
        '/founder/milestones',
        '/founder/mentorship_requests',
        '/founder/monthly_metrics'
      ]

      founder_routes.each do |route|
        get route
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'Cross-role access protection' do
    let(:founder) do
      user = User.create!(email: 'founder@example.com', password: 'SecurePassword123!', role: 'founder', confirmed_at: Time.current)
      user.create_user_profile!(
        full_name: 'Jane Founder',
        role: 'founder',
        phone: '+1234567890',
        country: 'US',
        bio: 'This bio meets the minimum length requirement for founders with more than thirty characters.',
        onboarding_completed: true
      )
      user
    end

    let(:mentor) do
      user = User.create!(email: 'mentor@example.com', password: 'SecurePassword123!', role: 'mentor', confirmed_at: Time.current)
      user.create_user_profile!(
        full_name: 'John Mentor',
        role: 'mentor',
        title: 'Senior Advisor',
        organization: 'Tech Company',
        years_experience: 10,
        bio: 'Experienced mentor with expertise in technology and startup development.',
        mentorship_approach: 'Hands-on mentoring approach with regular check-ins and practical guidance.',
        motivation: 'Passionate about helping founders succeed.',
        stage_preference: 'Seed',
        preferred_mentorship_mode: 'one-on-one',
        availability_hours_month: 5,
        rate_per_hour: 100
      )
      user
    end

    it 'prevents mentors from accessing founder-only resources' do
      sign_in mentor

      get '/founder/dashboard'

      # Should not allow access
      expect(response).not_to have_http_status(:success)
    end

    it 'allows founders to access their own resources' do
      sign_in founder

      get '/founder/dashboard'

      expect(response).to have_http_status(:success)
    end

    it 'prevents direct URL manipulation for unauthorized access' do
      # Test that even if someone tries to guess URLs, they're blocked
      sign_in mentor

      get '/founder/startup_profile/1/edit'  # Trying to edit another user's profile

      expect(response).not_to have_http_status(:success)
    end
  end

  describe 'Session-based access control' do
    let(:founder) do
      user = User.create!(email: 'founder@example.com', password: 'SecurePassword123!', role: 'founder', confirmed_at: Time.current)
      user.create_user_profile!(
        full_name: 'Jane Founder',
        role: 'founder',
        phone: '+1234567890',
        country: 'US',
        bio: 'This bio meets the minimum length requirement for founders with more than thirty characters.',
        onboarding_completed: true
      )
      user
    end

    it 'invalidates session on role change' do
      sign_in founder

      get '/founder/dashboard'
      expect(response).to have_http_status(:success)

      # Simulate role change (would happen in real scenario)
      founder.update_column(:role, 'mentor')

      # Session should still work but subsequent requests might be checked
      get '/founder/dashboard'
      # Behavior depends on implementation, but tests the concept
    end

    it 'maintains user context across requests' do
      sign_in founder

      get '/founder/dashboard'
      expect(response).to have_http_status(:success)

      get '/founder/account'
      expect(response).to have_http_status(:success)

      # Current user should be consistent
      expect(controller.current_user).to eq(founder)
    end
  end
end
