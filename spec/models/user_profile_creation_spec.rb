require 'rails_helper'

RSpec.describe 'User Profile and Startup Profile Creation' do
  describe 'UserProfile creation' do
    let(:user) { User.create!(email: 'founder@example.com', password: 'SecurePassword123!', role: 'founder', confirmed_at: Time.current) }

    it 'creates user profile with valid founder data' do
      user_profile = user.create_user_profile!(
        full_name: 'Jane Founder',
        role: 'founder',
        phone: '+1234567890',
        country: 'US',
        bio: 'Passionate entrepreneur building innovative solutions for real-world problems with at least 30 characters.'
      )

      expect(user_profile).to be_persisted
      expect(user_profile.role).to eq('founder')
      expect(user_profile.full_name).to eq('Jane Founder')
      expect(user_profile.phone).to eq('+1234567890')
      expect(user_profile.country).to eq('US')
    end

    it 'creates user profile with valid mentor data' do
      mentor_user = User.create!(email: 'mentor@example.com', password: 'SecurePassword123!', role: 'mentor', confirmed_at: Time.current)

      user_profile = mentor_user.create_user_profile!(
        full_name: 'John Mentor',
        role: 'mentor',
        title: 'Senior Tech Advisor',
        organization: 'Tech Ventures Inc',
        years_experience: 15,
        bio: 'Experienced technology leader with expertise in scaling startups and enterprise software development with detailed background.',
        linkedin_url: 'https://linkedin.com/in/mentor',
        expertise: [ 'Ruby', 'JavaScript', 'Startup Strategy' ],
        sectors: [ 'Technology', 'SaaS', 'Enterprise' ],
        mentorship_approach: 'I believe in hands-on mentoring with regular check-ins and practical guidance based on real-world experience in scaling technology companies from seed to series B.',
        motivation: 'Passionate about giving back to the startup community and helping founders avoid common pitfalls while building successful companies.',
        stage_preference: 'Seed',
        preferred_mentorship_mode: 'one-on-one',
        availability_hours_month: 10,
        rate_per_hour: 100
      )

      expect(user_profile).to be_persisted
      expect(user_profile.role).to eq('mentor')
      expect(user_profile.full_name).to eq('John Mentor')
      expect(user_profile.title).to eq('Senior Tech Advisor')
      expect(user_profile.years_experience).to eq(15)
    end

    it 'validates required founder fields' do
      invalid_profile = user.build_user_profile(
        full_name: 'Test',
        role: 'founder'
        # Missing phone, country, bio
      )

      expect(invalid_profile).not_to be_valid
      expect(invalid_profile.errors[:phone]).to be_present
      expect(invalid_profile.errors[:country]).to be_present
      expect(invalid_profile.errors[:bio]).to be_present
    end

    it 'validates required mentor fields' do
      mentor_user = User.create!(email: 'mentor2@example.com', password: 'SecurePassword123!', role: 'mentor', confirmed_at: Time.current)

      invalid_profile = mentor_user.build_user_profile(
        full_name: 'Test Mentor',
        role: 'mentor'
        # Missing mentor-specific fields
      )

      expect(invalid_profile).not_to be_valid
      expect(invalid_profile.errors[:title]).to be_present
      expect(invalid_profile.errors[:organization]).to be_present
      expect(invalid_profile.errors[:years_experience]).to be_present
    end

    it 'associates user profile with user' do
      user_profile = user.create_user_profile!(
        full_name: 'Test Founder',
        role: 'founder',
        phone: '+1234567890',
        country: 'US',
        bio: 'This bio meets the minimum length requirement for founders with more than thirty characters.'
      )

      expect(user_profile.user).to eq(user)
      expect(user.user_profile).to eq(user_profile)
    end

    it 'generates slug automatically' do
      user_profile = user.create_user_profile!(
        full_name: 'Jane Smith',
        role: 'founder',
        phone: '+1234567890',
        country: 'US',
        bio: 'This bio meets the minimum length requirement for founders with more than thirty characters.'
      )

      expect(user_profile.slug).to eq('jane-smith')
    end

    it 'ensures slug uniqueness' do
      user2 = User.create!(email: 'user2@example.com', password: 'SecurePassword123!', role: 'founder', confirmed_at: Time.current)

      # Create first profile and verify slug
      profile1 = user.create_user_profile!(
        full_name: 'John Doe',
        role: 'founder',
        phone: '+1234567890',
        country: 'US',
        bio: 'This bio meets the minimum length requirement for founders with more than thirty characters.'
      )

      # Reset slug generation counter by creating a different name first
      user2.create_user_profile!(
        full_name: 'Jane Smith',
        role: 'founder',
        phone: '+1234567892',
        country: 'US',
        bio: 'This bio meets the minimum length requirement for founders with more than thirty characters.'
      )

      # Now create the duplicate name
      profile2 = user2.build_user_profile(
        full_name: 'John Doe',
        role: 'founder',
        phone: '+1234567893',
        country: 'US',
        bio: 'This bio also meets the minimum length requirement for founders with more than thirty characters.'
      )

      # Manually set the slug to test uniqueness
      profile2.slug = 'john-doe'
      profile2.valid?
      expect(profile2.errors[:slug]).to be_present
    end
  end

  describe 'StartupProfile creation' do
    let(:user) { User.create!(email: 'founder@example.com', password: 'SecurePassword123!', role: 'founder', confirmed_at: Time.current) }

    it 'creates startup profile with valid data' do
      startup_profile = user.create_startup_profile!(
        startup_name: 'TechVenture',
        sector: 'Technology',
        stage: 'Seed',
        funding_stage: 'Pre-seed',
        description: 'Innovative platform for startup growth.',
        website_url: 'https://techventure.com',
        team_size: 5,
        target_market: 'Early-stage startups',
        value_proposition: 'Connect startups with experienced mentors'
      )

      expect(startup_profile).to be_persisted
      expect(startup_profile.startup_name).to eq('TechVenture')
      expect(startup_profile.sector).to eq('Technology')
      expect(startup_profile.stage).to eq('Seed')
      expect(startup_profile.funding_stage).to eq('Pre-seed')
      expect(startup_profile.team_size).to eq(5)
    end

    it 'associates with user correctly' do
      startup_profile = user.create_startup_profile!(
        startup_name: 'TechVenture',
        sector: 'Technology',
        stage: 'Seed',
        funding_stage: 'Pre-seed',
        description: 'Innovative platform for startup growth.',
        target_market: 'Early-stage startups',
        value_proposition: 'Connect startups with experienced mentors'
      )

      expect(startup_profile.user).to eq(user)
      expect(user.startup_profile).to eq(startup_profile)
    end

    it 'validates presence of required fields' do
      # Test each required field individually
      required_fields = %w[startup_name description stage target_market value_proposition]

      required_fields.each do |field|
        # Create an invalid startup profile missing this field
        startup_profile = user.build_startup_profile
        startup_profile.startup_name = 'Test Startup' unless field == 'startup_name'
        startup_profile.sector = 'Technology' unless field == 'sector'
        startup_profile.stage = 'Seed' unless field == 'stage'
        startup_profile.funding_stage = 'Pre-seed' unless field == 'funding_stage'
        startup_profile.description = 'Test description' unless field == 'description'
        startup_profile.target_market = 'Test market' unless field == 'target_market'
        startup_profile.value_proposition = 'Test value' unless field == 'value_proposition'

        # Set onboarding step to trigger validation
        startup_profile.onboarding_step = 'confirm'
        startup_profile.valid?

        # Check for validation errors (skip if it's a conditional field)
        if %w[startup_name description stage target_market value_proposition].include?(field)
          expect(startup_profile.errors[field]).to be_present, "Should validate presence of #{field}"
        end
      end
    end

    it 'validates website URL format' do
      invalid_websites = [
        'not-a-url',
        'ftp://invalid-protocol.com',
        'invalid-domain'
      ]

      invalid_websites.each do |website_url|
        startup_profile = user.build_startup_profile(
          startup_name: 'Test Startup',
          sector: 'Technology',
          stage: 'Seed',
          description: 'Test description',
          target_market: 'Test market',
          value_proposition: 'Test value',
          website_url: website_url
        )

        startup_profile.valid?
        expect(startup_profile.errors[:website_url]).to be_present
      end
    end

    it 'accepts valid website URLs' do
      valid_websites = [
        'https://techventure.com',
        'http://www.startup.co',
        'https://platform.example.org'
      ]

      valid_websites.each do |website_url|
        startup_profile = user.build_startup_profile(
          startup_name: 'Test Startup',
          sector: 'Technology',
          stage: 'Seed',
          description: 'Test description',
          target_market: 'Test market',
          value_proposition: 'Test value',
          website_url: website_url
        )

        startup_profile.valid?
        expect(startup_profile.errors[:website_url]).to be_blank
      end
    end
  end

  describe 'Profile destruction cascading' do
    it 'destroys user profile when user is destroyed' do
      user = User.create!(email: 'founder@example.com', password: 'SecurePassword123!', role: 'founder', confirmed_at: Time.current)
      user.create_user_profile!(
        full_name: 'Test Founder',
        role: 'founder',
        phone: '+1234567890',
        country: 'US',
        bio: 'This bio meets the minimum length requirement for founders with more than thirty characters.'
      )

      expect { user.destroy }.to change(UserProfile, :count).by(-1)
    end

    it 'destroys startup profile when user is destroyed' do
      user = User.create!(email: 'founder@example.com', password: 'SecurePassword123!', role: 'founder', confirmed_at: Time.current)
      user.create_startup_profile!(
        startup_name: 'Test Startup',
        sector: 'Technology',
        stage: 'Seed',
        funding_stage: 'Pre-seed',
        description: 'Test description',
        target_market: 'Test market',
        value_proposition: 'Test value'
      )

      expect { user.destroy }.to change(StartupProfile, :count).by(-1)
    end
  end
end
