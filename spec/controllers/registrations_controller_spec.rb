require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:founder_params) do
    {
      email: 'founder@example.com',
      password: 'SecurePassword123!',
      password_confirmation: 'SecurePassword123!',
      role: 'founder'
    }
  end

  let(:founder_onboarding_data) do
    {
      'full_name' => 'Jane Founder',
      'email' => 'founder@example.com',
      'phone' => '+1234567890',
      'country' => 'US',
      'city' => 'San Francisco',
      'startup_name' => 'TechVenture',
      'industry' => 'Technology',
      'stage' => 'Seed',
      'description' => 'An innovative startup'
    }
  end

  let(:mentor_onboarding_data) do
    {
      'full_name' => 'John Mentor',
      'email' => 'mentor@example.com',
      'years_experience' => '10',
      'expertise' => 'Ruby, JavaScript',
      'linkedin_url' => 'https://linkedin.com/in/mentor'
    }
  end

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe '#create' do
    context 'with founder onboarding data' do
      before do
        fs = Onboarding::SessionStore.new(session, namespace: :founders)
        fs.merge!(founder_onboarding_data)
      end

      it 'creates user with founder role' do
        post :create, params: { user: founder_params }

        expect(User.count).to eq(1)
        user = User.last
        expect(user.email).to eq('founder@example.com')
        expect(user.founder?).to be true
      end

      it 'creates user profile with founder data' do
        post :create, params: { user: founder_params }

        user = User.last
        profile = user.user_profile
        expect(profile).to be_present
        expect(profile.role).to eq('founder')
        expect(profile.full_name).to eq('Jane Founder')
        expect(profile.phone).to eq('+1234567890')
        expect(profile.country).to eq('US')
        expect(profile.city).to eq('San Francisco')
      end

      it 'creates startup profile with startup data' do
        post :create, params: { user: founder_params }

        user = User.last
        startup_profile = user.startup_profile
        expect(startup_profile).to be_present
        expect(startup_profile.startup_name).to eq('TechVenture')
        expect(startup_profile.industry).to eq('Technology')
        expect(startup_profile.stage).to eq('Seed')
        expect(startup_profile.description).to eq('An innovative startup')
      end

      it 'sets pending flash message for founders' do
        post :create, params: { user: founder_params }

        expect(flash[:notice]).to eq('Thanks for signing up. We\'ll review your application and send an approval email shortly.')
      end

      it 'notifies admins of new founder submission' do
        expect(Notifications::OnboardingNotifier).to receive(:notify_admin_of_submission).with(
          hash_including(
            user: instance_of(User),
            role: :founders,
            payload: hash_including(
              user_profile: hash_including('role' => 'founder'),
              startup_profile: hash_including('startup_name' => 'TechVenture')
            )
          )
        )

        post :create, params: { user: founder_params }
      end

      it 'clears onboarding session data' do
        post :create, params: { user: founder_params }

        expect(session[:onboarding_founders]).to be_nil
      end

      it 'does not sign in founder immediately' do
        post :create, params: { user: founder_params }

        expect(controller.send(:user_signed_in?)).to be false
      end

      context 'in development environment' do
        before do
          allow(Rails).to receive(:env).and_return(ActiveSupport::EnvironmentInquirer.new('development'))
        end

        it 'creates dev confirmation link' do
          post :create, params: { user: founder_params }

          user = User.last
          expect(user.confirmation_token).to be_present
          expect(user.confirmation_sent_at).to be_present
        end
      end

      context 'when user persistence fails' do
        it 'logs error and continues' do
          allow_any_instance_of(User).to receive(:save).and_return(false)
          allow_any_instance_of(User).to receive(:errors).and_return(
            double(full_messages: [ 'Email is invalid' ])
          )

          expect(Rails.logger).to receive(:error).with(/could not persist user before creating profiles/)

          post :create, params: { user: founder_params }
        end
      end

      context 'when user profile creation fails' do
        it 'logs error but continues' do
          allow_any_instance_of(UserProfile).to receive(:persisted?).and_return(false)
          allow_any_instance_of(UserProfile).to receive(:errors).and_return(
            double(full_messages: [ 'Profile validation failed' ])
          )

          expect(Rails.logger).to receive(:error).with(/failed to create user_profile/)

          post :create, params: { user: founder_params }
        end
      end

      context 'when startup profile creation fails' do
        it 'logs error but continues' do
          allow_any_instance_of(StartupProfile).to receive(:persisted?).and_return(false)
          allow_any_instance_of(StartupProfile).to receive(:errors).and_return(
            double(full_messages: [ 'Startup profile validation failed' ])
          )

          expect(Rails.logger).to receive(:error).with(/failed to create startup_profile/)

          post :create, params: { user: founder_params }
        end
      end
    end

    context 'with mentor onboarding data' do
      before do
        ms = Onboarding::SessionStore.new(session, namespace: :mentors)
        ms.merge!(mentor_onboarding_data)
      end

      it 'creates user profile with mentor data' do
        mentor_params = founder_params.merge(role: 'mentor')
        post :create, params: { user: mentor_params }

        user = User.last
        profile = user.user_profile
        expect(profile).to be_present
        expect(profile.role).to eq('mentor')
        expect(profile.full_name).to eq('John Mentor')
      end

      it 'signs in mentor immediately' do
        mentor_params = founder_params.merge(role: 'mentor')
        post :create, params: { user: mentor_params }

        expect(controller.send(:user_signed_in?)).to be true
      end

      it 'sets welcome flash message for mentors' do
        mentor_params = founder_params.merge(role: 'mentor')
        post :create, params: { user: mentor_params }

        expect(flash[:notice]).to include('Welcome to Nailab!')
      end
    end

    context 'without onboarding data' do
      it 'creates user with basic registration' do
        post :create, params: { user: founder_params }

        expect(User.count).to eq(1)
        user = User.last
        expect(user.email).to eq('founder@example.com')
      end

      it 'creates default user profile' do
        post :create, params: { user: founder_params }

        user = User.last
        expect(user.user_profile).to be_present
      end
    end

    context 'when notification fails' do
      before do
        fs = Onboarding::SessionStore.new(session, namespace: :founders)
        fs.merge!(founder_onboarding_data)
      end

      it 'logs error but continues' do
        allow(Notifications::OnboardingNotifier).to receive(:notify_admin_of_submission).and_raise(StandardError.new('Notification failed'))

        expect(Rails.logger).to receive(:error).with(/failed to notify admin of submission/)

        post :create, params: { user: founder_params }

        expect(User.count).to eq(1)
      end
    end
  end

  describe '#after_sign_up_path_for' do
    it 'redirects to founder onboarding for founders' do
      founder = User.new(role: 'founder')
      expect(controller.send(:after_sign_up_path_for, founder)).to eq(founder_onboarding_path)
    end

    it 'redirects to mentor root for mentors' do
      mentor = User.new(role: 'mentor')
      expect(controller.send(:after_sign_up_path_for, mentor)).to eq(mentor_root_path)
    end

    it 'redirects to root for other roles' do
      user = User.new(role: 'partner')
      expect(controller.send(:after_sign_up_path_for, user)).to eq(root_path)
    end
  end

  describe '#after_sign_in_path_for' do
    it 'redirects to founder onboarding for founders' do
      founder = User.new(role: 'founder')
      expect(controller.send(:after_sign_in_path_for, founder)).to eq(founder_onboarding_path)
    end

    it 'redirects to mentor root for mentors' do
      mentor = User.new(role: 'mentor')
      expect(controller.send(:after_sign_in_path_for, mentor)).to eq(mentor_root_path)
    end

    it 'redirects to root for other roles' do
      user = User.new(role: 'partner')
      expect(controller.send(:after_sign_in_path_for, user)).to eq(root_path)
    end
  end

  describe 'parameter sanitization' do
    it 'permits correct sign_up params' do
      controller.params = ActionController::Parameters.new({
        user: {
          email: 'test@example.com',
          password: 'SecurePassword123!',
          password_confirmation: 'SecurePassword123!',
          role: 'founder',
          admin: true
        }
      })

      allowed_params = controller.send(:sign_up_params)
      expect(allowed_params.to_h).to eq({
        'email' => 'test@example.com',
        'password' => 'SecurePassword123!',
        'password_confirmation' => 'SecurePassword123!',
        'role' => 'founder'
      })
    end

    it 'permits correct account_update params' do
      controller.params = ActionController::Parameters.new({
        user: {
          email: 'new@example.com',
          password: 'NewPassword123!',
          password_confirmation: 'NewPassword123!',
          current_password: 'SecurePassword123!',
          role: 'admin',
          admin: true
        }
      })

      allowed_params = controller.send(:account_update_params)
      expect(allowed_params.to_h).to eq({
        'email' => 'new@example.com',
        'password' => 'NewPassword123!',
        'password_confirmation' => 'NewPassword123!',
        'current_password' => 'SecurePassword123!',
        'role' => 'admin'
      })
    end
  end
end
