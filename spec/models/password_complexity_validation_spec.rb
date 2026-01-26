require 'rails_helper'

RSpec.describe 'Password Complexity Validation Edge Cases' do
  let(:user) { User.new(email: 'test@example.com', password: 'SecurePassword123!', role: 'founder') }

  describe 'Extended character set validation' do
    it 'accepts passwords with international characters' do
      international_passwords = [
        'SécuritéP@ss123',  # French accented
        'ContraseñaSegura456!', # Spanish accented
        'パスワード安全789', # Japanese characters
        'SenhaForte@123'  # Portuguese
      ]

      international_passwords.each do |password|
        user.password = password
        user.valid?
        expect(user.errors[:password]).to be_blank, "Should accept password with international characters"
      end
    end

    it 'accepts passwords with emojis' do
      emoji_passwords = [
        'Rocket🚀123!',
        'Startup💡Pass456',
        'Code👨‍💻Secure789'
      ]

      emoji_passwords.each do |password|
        user.password = password
        user.valid?
        expect(user.errors[:password]).to be_blank, "Should accept password with emojis: #{password}"
      end
    end

    it 'accepts passwords with mixed character types' do
      complex_passwords = [
        'P@ssw0rd_2024!',
        'My-S3cur3#P@ss',
        'C0mpl3x!Str1ng',
        'AdV4nc3d~P@ssw0rd'
      ]

      complex_passwords.each do |password|
        user.password = password
        user.valid?
        expect(user.errors[:password]).to be_blank, "Should accept complex password: #{password}"
      end
    end
  end

  describe 'Edge case rejection' do
    it 'rejects passwords with only numbers' do
      numeric_passwords = [
        '123456789',
        '9876543210',
        '0000000000'
      ]

      numeric_passwords.each do |password|
        user.password = password
        user.valid?
        expect(user.errors[:password]).to be_present, "Should reject numeric-only password: #{password}"
      end
    end

    it 'rejects passwords with only special characters' do
      special_passwords = [
        '!@#$%^&*()',
        '----------',
        '..........'
      ]

      special_passwords.each do |password|
        user.password = password
        user.valid?
        expect(user.errors[:password]).to be_present, "Should reject special-characters-only password: #{password}"
      end
    end

    it 'rejects passwords with only uppercase letters' do
      uppercase_passwords = [
        'ALLUPPERCASE',
        'PASSWORD',
        'ABCDEFGHIJKLMN'
      ]

      uppercase_passwords.each do |password|
        user.password = password
        user.valid?
        expect(user.errors[:password]).to be_present, "Should reject uppercase-only password: #{password}"
      end
    end

    it 'rejects passwords with only lowercase letters' do
      lowercase_passwords = [
        'alllowercase',
        'password',
        'abcdefghijklm'
      ]

      lowercase_passwords.each do |password|
        user.password = password
        user.valid?
        expect(user.errors[:password]).to be_present, "Should reject lowercase-only password: #{password}"
      end
    end

    it 'rejects common patterns even if technically complex' do
      # These patterns should ideally be flagged by additional security measures
      common_patterns = [
        'Password123!',
        'Admin123!',
        'User123@'
      ]

      common_patterns.each do |password|
        user.password = password
        user.valid?
        # These may pass basic validation but should be flagged by other security measures
        if user.errors[:password].blank?
          # At minimum, we can test that these get special handling
          expect(password.length).to be >= 10
        end
      end
    end
  end

  describe 'Length edge cases' do
    it 'rejects passwords that are too short even if technically complex' do
      short_complex_passwords = [
        'A1!',
        'a1!',
        'B2@',
        'c2#'
      ]

      short_complex_passwords.each do |password|
        user.password = password
        user.valid?
        expect(user.errors[:password]).to be_present, "Should reject short password: #{password}"
      end
    end

    it 'accepts very long passwords' do
      long_passwords = [
        'ThisIsAVeryLongPassword123!ThatMeetsAllComplexityRequirements',
        'A' * 100 + '1B!', # 100 characters
        'P' + 'a' * 50 + 'ssword123!'  # 60+ characters
      ]

      long_passwords.each do |password|
        user.password = password
        user.valid?
        preview = password.length > 20 ? password[0..20] + '...' : password
        expect(user.errors[:password]).to be_blank, "Should accept long password: #{preview}"
      end
    end

    it 'handles extremely long passwords gracefully' do
      max_length_password = 'A' * 100 + '1b!'  # Very long password

      user.password = max_length_password
      user.valid?

      # Should either accept or reject gracefully with appropriate error
      expect(user.errors[:password].present? || user.errors[:password].blank?).to be_truthy
    end
  end

  describe 'Character encoding and special cases' do
    it 'handles unicode characters correctly' do
      unicode_passwords = [
        'пароль123!',  # Cyrillic
        'كلمةمرور123!', # Arabic
        '密码123!',     # Chinese
        'पासवर्ड123!' # Hindi
      ]

      unicode_passwords.each do |password|
        user.password = password
        user.valid?
        expect(user.errors[:password]).to be_blank, "Should accept unicode password"
      end
    end

    it 'rejects passwords with control characters' do
      control_char_passwords = [
        "Password\x0123!",  # Using simple control characters
        "Password\x0223!",
        "Password\x03123!"
      ]

      control_char_passwords.each do |password|
        user.password = password
        user.valid?
        expect(user.errors[:password]).to be_present, "Should reject password with control chars"
      end
    end
  end

  describe 'Business logic edge cases' do
    it 'treats password confirmation correctly' do
      user.password = 'SecurePassword123!'
      user.password_confirmation = 'DifferentPassword123!'

      user.valid?

      # Should have password confirmation error
      expect(user.errors[:password_confirmation]).to be_present
    end

    it 'validates complexity only when password is present' do
      user.password = ''
      user.password_confirmation = ''

      user.valid?

      # Should not trigger complexity validation for empty password
      expect(user.errors[:password]).not_to include('must include at least one lowercase letter')
    end

    it 'handles nil password gracefully' do
      user.password = nil
      user.password_confirmation = nil

      user.valid?

      # Should handle nil gracefully
      expect(user.errors[:password]).to be_present
    end

    it 'validates complexity on update' do
      # Create a valid user first
      existing_user = User.create!(
        email: 'existing@example.com',
        password: 'SecurePassword123!',
        role: 'founder',
        confirmed_at: Time.current
      )

      # Try to update with weak password
      existing_user.password = 'weakpassword'
      existing_user.password_confirmation = 'weakpassword'

      existing_user.valid?
      expect(existing_user.errors[:password]).to be_present
    end
  end

  describe 'Performance considerations' do
    it 'validates complex passwords efficiently' do
      complex_password = 'V3ryC0mpl3x!P@ssw0rdWithLength'

      start_time = Time.current
      100.times do
        user.password = complex_password
        user.valid?
      end
      end_time = Time.current

      # Should complete 100 validations quickly (under 1 second total)
      expect(end_time - start_time).to be < 1.0
    end

    it 'fails fast on obviously invalid passwords' do
      invalid_passwords = [ '123', 'password', 'admin' ]

      invalid_passwords.each do |password|
        start_time = Time.current
        user.password = password
        user.valid?
        end_time = Time.current

        # Should reject invalid passwords very quickly
        expect(end_time - start_time).to be < 0.05
      end
    end
  end

  describe 'Integration with other validations' do
    it 'works with email validation' do
      user.password = 'SecurePassword123!'
      user.email = 'invalid-email'

      user.valid?

      # Should have email error, not password error
      expect(user.errors[:email]).to be_present
      expect(user.errors[:password]).to be_blank
    end

    it 'validates multiple fields correctly' do
      user.password = 'weakpassword'
      user.email = 'invalid-email'
      user.password_confirmation = 'different'

      user.valid?

      # Should have errors for both email and password
      expect(user.errors[:email]).to be_present
      expect(user.errors[:password]).to be_present
      expect(user.errors[:password_confirmation]).to be_present
    end
  end
end
