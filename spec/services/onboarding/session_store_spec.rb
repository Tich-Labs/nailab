require 'rails_helper'

RSpec.describe Onboarding::SessionStore, type: :service do
  let(:session) { {} }
  let(:founder_store) { described_class.new(session, namespace: :founders) }
  let(:mentor_store) { described_class.new(session, namespace: :mentors) }

  describe '#initialize' do
    it 'sets up namespace correctly' do
      store = described_class.new(session, namespace: :founders)
      expect(store.instance_variable_get(:@namespace)).to eq(:onboarding_founders)
    end

    it 'creates empty hash for new namespace' do
      expect(session[:onboarding_founders]).to be_nil
      store = described_class.new(session, namespace: :founders)
      expect(session[:onboarding_founders]).to eq({})
    end

    it 'uses existing namespace data' do
      session[:onboarding_mentors] = { 'name' => 'John' }
      store = described_class.new(session, namespace: :mentors)
      expect(store.to_h).to eq({ 'name' => 'John' })
    end

    it 'handles nil session gracefully' do
      store = described_class.new(nil, namespace: :founders)
      expect(store.read('test')).to be_nil
    end
  end

  describe '#read' do
    it 'reads value from session' do
      session[:onboarding_founders] = { 'email' => 'founder@example.com' }
      expect(founder_store.read('email')).to eq('founder@example.com')
    end

    it 'converts key to string' do
      session[:onboarding_founders] = { 'email' => 'founder@example.com' }
      expect(founder_store.read(:email)).to eq('founder@example.com')
    end

    it 'returns nil for non-existent key' do
      expect(founder_store.read('nonexistent')).to be_nil
    end

    it 'handles empty session' do
      expect(founder_store.read('any_key')).to be_nil
    end
  end

  describe '#write' do
    it 'writes value to session' do
      founder_store.write('email', 'founder@example.com')
      expect(session[:onboarding_founders]['email']).to eq('founder@example.com')
    end

    it 'converts key to string' do
      founder_store.write(:email, 'founder@example.com')
      expect(session[:onboarding_founders]['email']).to eq('founder@example.com')
    end

    it 'overwrites existing value' do
      founder_store.write('email', 'old@example.com')
      founder_store.write('email', 'new@example.com')
      expect(session[:onboarding_founders]['email']).to eq('new@example.com')
    end
  end

  describe '#merge!' do
    it 'merges hash into session data' do
      session[:onboarding_founders] = { 'existing' => 'value' }
      founder_store.merge!({ 'new' => 'data', 'another' => 'item' })

      expect(session[:onboarding_founders]).to eq({
        'existing' => 'value',
        'new' => 'data',
        'another' => 'item'
      })
    end

    it 'converts symbol keys to strings' do
      founder_store.merge!({ email: 'test@example.com', name: 'John' })

      expect(session[:onboarding_founders]).to eq({
        'email' => 'test@example.com',
        'name' => 'John'
      })
    end

    it 'handles empty session' do
      founder_store.merge!({ 'key' => 'value' })
      expect(session[:onboarding_founders]).to eq({ 'key' => 'value' })
    end
  end

  describe '#to_h' do
    it 'returns the session hash for namespace' do
      session[:onboarding_founders] = { 'email' => 'test@example.com', 'name' => 'John' }
      expect(founder_store.to_h).to eq({
        'email' => 'test@example.com',
        'name' => 'John'
      })
    end

    it 'returns empty hash for empty namespace' do
      expect(founder_store.to_h).to eq({})
    end
  end

  describe 'namespace isolation' do
    it 'separates data by namespace' do
      founder_store.write('role', 'founder')
      mentor_store.write('role', 'mentor')

      expect(founder_store.read('role')).to eq('founder')
      expect(mentor_store.read('role')).to eq('mentor')
    end

    it 'does not interfere with other namespaces' do
      founder_store.merge!({ 'email' => 'founder@example.com', 'company' => 'Startup Co' })
      mentor_store.merge!({ 'email' => 'mentor@example.com', 'experience' => '10 years' })

      expect(session[:onboarding_founders]).to eq({
        'email' => 'founder@example.com',
        'company' => 'Startup Co'
      })

      expect(session[:onboarding_mentors]).to eq({
        'email' => 'mentor@example.com',
        'experience' => '10 years'
      })
    end
  end

  describe 'integration with registration flow' do
    it 'properly stores founder onboarding data' do
      founder_data = {
        'full_name' => 'Jane Founder',
        'email' => 'jane@startup.com',
        'phone' => '+1234567890',
        'country' => 'US',
        'city' => 'San Francisco',
        'startup_name' => 'TechVenture',
        'industry' => 'Technology',
        'stage' => 'Seed'
      }

      founder_store.merge!(founder_data)

      expect(founder_store.to_h).to eq(founder_data)
      expect(session[:onboarding_founders]).to eq(founder_data)
    end

    it 'handles complex data types' do
      complex_data = {
        'skills' => [ 'Ruby', 'JavaScript', 'Leadership' ],
        'funding_round' => { 'amount' => 1000000, 'type' => 'seed' },
        'team_size' => 5
      }

      founder_store.merge!(complex_data)
      expect(founder_store.read('skills')).to eq([ 'Ruby', 'JavaScript', 'Leadership' ])
      expect(founder_store.read('funding_round')).to eq({ 'amount' => 1000000, 'type' => 'seed' })
    end
  end
end
