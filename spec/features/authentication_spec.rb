require 'rails_helper'

RSpec.describe 'Authentication Flow' do
  describe 'User roles' do
    it 'creates founder with correct permissions' do
      founder = create(:user, :founder)

      expect(founder.founder?).to be true
      expect(founder.admin?).to be false
      expect(founder.mentor?).to be false
    end

    it 'creates mentor with correct permissions' do
      mentor = create(:user, :mentor)

      expect(mentor.mentor?).to be true
      expect(mentor.admin?).to be false
      expect(mentor.founder?).to be false
    end

    it 'creates admin with correct permissions' do
      admin = create(:user, :admin)

      expect(admin.admin?).to be true
      expect(admin.founder?).to be false
      expect(admin.mentor?).to be false
    end
  end

  describe 'Email validation' do
    it 'enforces unique email addresses' do
      create(:user, email: 'test@example.com')
      duplicate = build(:user, email: 'test@example.com')

      expect(duplicate).not_to be_valid
    end
  end

  describe 'Password requirements' do
    it 'accepts strong passwords' do
      user = build(:user, password: 'SecurePass123!')
      expect(user).to be_valid
    end

    it 'rejects weak passwords' do
      user = build(:user, password: 'password')
      user.valid?

      expect(user.errors[:password]).to be_present
    end
  end

  describe 'Security configuration' do
    it 'loads rate limiting' do
      expect(Rack::Attack.respond_to?(:throttles)).to be true
    end

    it 'includes security headers' do
      headers = Rails.application.config.action_dispatch.default_headers
      expect(headers['X-Frame-Options']).to eq('DENY')
    end
  end
end
