require 'rails_helper'

RSpec.describe User, type: :model do
  let(:founder) { build(:user, :founder) }
  let(:mentor) { build(:user, :mentor) }
  let(:partner) { build(:user, :partner) }
  let(:admin) { build(:user, :admin) }

  describe 'Role-based authentication' do
    context 'with enum roles' do
      it 'correctly assigns founder role' do
        founder.role = 'founder'
        expect(founder).to be_founder
        expect(founder).not_to be_mentor
        expect(founder).not_to be_admin
      end

      it 'correctly assigns mentor role' do
        mentor.role = 'mentor'
        expect(mentor).to be_mentor
        expect(mentor).not_to be_founder
        expect(mentor).not_to be_admin
      end

      it 'correctly assigns partner role' do
        partner.role = 'partner'
        expect(partner).to be_partner
        expect(partner).not_to be_founder
        expect(partner).not_to be_mentor
        expect(partner).not_to be_admin
      end

      it 'correctly assigns admin role' do
        admin.role = 'admin'
        expect(admin).to be_admin
        expect(admin).not_to be_founder
        expect(admin).not_to be_mentor
      end
    end

    context 'role-based permissions' do
      it 'founder should not have privileged access' do
        expect(founder.privileged?).to be false
      end

      it 'mentor should have privileged access' do
        expect(mentor.privileged?).to be true
      end

      it 'admin should have privileged access' do
        expect(admin.privileged?).to be true
      end
    end
  end

  describe 'Password complexity validation' do
    context 'with valid passwords' do
      valid_passwords = [
        'SecurePass123!',
        'MyPassword@2024',
        'StrongP@ssw0rd',
        'C0mpl3x!P@ss'
      ]

      valid_passwords.each do |password|
        it "accepts password: #{password}" do
          user = build(:user, password: password)
          expect(user).to be_valid
        end
      end
    end

    context 'with invalid passwords' do
      invalid_passwords = {
'password' => 'must include at least one lowercase letter, one uppercase letter, one digit, and one special character',
        'PASSWORD' => 'must include at least one lowercase letter',
        '123456' => 'must include at least one lowercase letter, one uppercase letter, and one special character',
        'Pass123' => 'must include at least one uppercase letter, and one special character',
        'Password!' => 'must include at least one digit',
        'emptypassword' => ''
      }

      invalid_passwords.each do |password, expected_error|
        it "rejects password: #{password}" do
          user = build(:user, password: password)
          user.valid?
          expect(user.errors[:password]).to include(expected_error)
        end
      end
    end
  end

  describe 'Email validation' do
    context 'with valid emails' do
      valid_emails = [
        'user@example.com',
        'test.user+alias@domain.co.uk',
        'user123@sub.domain.org'
      ]

      valid_emails.each do |email|
        it "accepts email: #{email}" do
          user = build(:user, email: email)
          expect(user).to be_valid
        end
      end
    end

    context 'with invalid emails' do
      invalid_emails = [
        'invalid-email',
        'user@',
        'user@domain',
        '@domain.com',
        'user domain.com'
      ]

      invalid_emails.each do |email|
        it "rejects email: #{email}" do
          user = build(:user, email: email)
          expect(user).not_to be_valid
          expect(user.errors[:email]).to be_present
        end
      end
    end
  end

  describe 'Email uniqueness' do
    it 'enforces unique email addresses' do
      existing_user = create(:user, email: 'existing@example.com')
      new_user = build(:user, email: 'existing@example.com')

      expect(new_user).not_to be_valid
      expect(new_user.errors[:email]).to include('has already been taken')
    end
  end

  describe 'Password hashing' do
    it 'stores encrypted passwords, not plain text' do
      password = 'SecretPassword123!'
      user = create(:user, password: password)

      expect(user.encrypted_password).not_to eq(password)
      expect(user.encrypted_password).not_to include('Secret')
      expect(user.encrypted_password.length).to be > 20  # BCrypt hashes are long
    end

    it 'verifies passwords correctly' do
      password = 'SecretPassword123!'
      user = create(:user, password: password)

      expect(user.valid_password?('SecretPassword123!')).to be true
      expect(user.valid_password?('WrongPassword')).to be false
    end
  end

  describe 'Slug generation' do
    it 'creates URL-friendly slugs' do
      user = build(:user, full_name: 'John Doe', email: 'john@example.com')
      user.valid?
      user.save!

      expect(user.slug).to eq('john-doe')
      expect(user.to_param).to eq('john-doe')
    end

    it 'ensures slug uniqueness' do
      user1 = create(:user, full_name: 'John Doe', email: 'john1@example.com')
      user2 = build(:user, full_name: 'John Doe', email: 'john2@example.com')
      user2.save!

      expect(user2.slug).not_to eq(user1.slug)
      expect(user2.slug).to eq('john-doe-2')
    end
  end

  describe 'Profile associations' do
    it 'creates user profile after user creation' do
      user = create(:user)
      expect(user.user_profile).to be_present
      expect(user.user_profile).to be_a(UserProfile)
    end

    it 'destroys user profile when user is destroyed' do
      user = create(:user)
      profile_id = user.user_profile.id

      expect { user.destroy }.to change(UserProfile, :count).by(-1)
    end
  end
end
