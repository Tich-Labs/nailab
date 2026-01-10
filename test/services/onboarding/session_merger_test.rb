require "test_helper"

class SessionMergerTest < ActiveSupport::TestCase
  class FakeProfile
    attr_reader :attrs
    def initialize
      @attrs = {}
    end

    def assign_attributes(h)
      @attrs.merge!(h)
    end

    def save
      true
    end

    def changed?
      true
    end
  end

  class FakeUser
    attr_accessor :user_profile, :startup_profile, :confirmed_at
    attr_reader :built

    def initialize
      @user_profile = nil
      @startup_profile = nil
      @built = {}
      @confirmed_at = nil
    end

    def build_user_profile
      @user_profile = FakeProfile.new
    end

    def build_startup_profile
      @startup_profile = FakeProfile.new
    end

    def confirm
      @confirmed_at = Time.current
    end
  end

  test "merges founder onboarding session into user profiles" do
    session = {}
    fs = Onboarding::SessionStore.new(session, namespace: :founders)
    fs.merge!(full_name: "Founding Founder", phone: "+254700000000", startup_name: "Acme", mentorship_areas: [ "sales" ])

    user = FakeUser.new

    merged = Onboarding::SessionMerger.merge(user, session)

    assert merged
    assert user.user_profile.present?
    assert_equal "Founding Founder", user.user_profile.attrs["full_name"]
    assert user.startup_profile.present?
    assert_equal "Acme", user.startup_profile.attrs["startup_name"]
    assert user.confirmed_at.present?
    assert_nil session[:onboarding_founders]
  end

  test "merges mentor onboarding session into user profile" do
    session = {}
    ms = Onboarding::SessionStore.new(session, namespace: :mentors)
    ms.merge!(full_name: "Mentor Max", phone: "+254711111111", mentorship_approach: "hands-on")

    user = FakeUser.new

    merged = Onboarding::SessionMerger.merge(user, session)

    assert merged
    assert user.user_profile.present?
    assert_equal "Mentor Max", user.user_profile.attrs["full_name"]
    assert user.confirmed_at.present?
    assert_nil session[:onboarding_mentors]
  end
end
