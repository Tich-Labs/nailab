require 'rails_helper'

RSpec.describe 'Authentication Security' do
  describe 'User role enum' do
    it 'defines correct roles' do
      expect(User.roles.keys).to include('founder', 'mentor', 'partner', 'admin')
      expect(User.roles[:founder]).to eq(0)
      expect(User.roles[:admin]).to eq(3)
    end
  end

  describe 'User role helper methods' do
    it 'correctly identifies admin users' do
      admin = User.new(role: :admin)
      expect(admin.admin?).to be true
      expect(admin.mentor?).to be false
      expect(admin.founder?).to be false
    end

    it 'correctly identifies mentor users' do
      mentor = User.new(role: :mentor)
      expect(mentor.mentor?).to be true
      expect(mentor.admin?).to be false
      expect(mentor.founder?).to be false
    end

    it 'correctly identifies founder users' do
      founder = User.new(role: :founder)
      expect(founder.founder?).to be true
      expect(founder.mentor?).to be false
      expect(founder.admin?).to be false
    end
  end

  describe 'Password complexity validation' do
    it 'accepts valid complex passwords' do
      user = User.new(password: 'SecurePass123!')
      user.valid?

      expect(user.errors[:password]).to be_nil
    end

    it 'rejects invalid simple passwords' do
      user = User.new(password: 'password')
      user.valid?

      expect(user.errors[:password]).to be_present
      expect(user.errors[:password].to_s).to include('must include at least one lowercase letter')
    end
  end

  describe 'Rate limiting configuration' do
    it 'loads Rack::Attack' do
      expect(defined?(Rack::Attack)).to be true
    end
  end

  describe 'Security headers configuration' do
    it 'includes X-Frame-Options header' do
      headers = Rails.application.config.action_dispatch.default_headers
      expect(headers['X-Frame-Options']).to eq('DENY')
    end

    it 'includes X-Content-Type-Options header' do
      headers = Rails.application.config.action_dispatch.default_headers
      expect(headers['X-Content-Type-Options']).to eq('nosniff')
    end

    it 'includes X-XSS-Protection header' do
      headers = Rails.application.config.action_dispatch.default_headers
      expect(headers['X-XSS-Protection']).to eq('1; mode=block')
    end

    it 'includes Content-Security-Policy header' do
      headers = Rails.application.config.action_dispatch.default_headers
      expect(headers['Content-Security-Policy']).to be_present
    end
  end
end
