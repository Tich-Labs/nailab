require "test_helper"

class FoundersAdapterTest < ActiveSupport::TestCase
  class FakeModel
    attr_reader :attrs, :errors
    def initialize
      @attrs = {}
      @errors = OpenStruct.new(full_messages: [])
    end

    def update(hash)
      @attrs.merge!(hash)
      true
    end
  end

  class FakeUser
    attr_accessor :user_profile, :startup_profile
    def initialize
      @user_profile = FakeModel.new
      @startup_profile = FakeModel.new
    end

    def build_user_profile
      @user_profile = FakeModel.new
    end

    def build_startup_profile
      @startup_profile = FakeModel.new
    end
  end

  test "personal step persists to user_profile for actor" do
    session_store = Onboarding::SessionStore.new({}, namespace: :founders)
    adapter = Onboarding::FoundersAdapter.new(session_store: session_store)
    user = FakeUser.new
    result = adapter.persist_step(actor: user, step: "personal", params: { full_name: "Alice" })
    assert result.success?
    assert_equal "Alice", user.user_profile.attrs[:full_name]
  end

  test "startup step persists to startup_profile for actor" do
    session_store = Onboarding::SessionStore.new({}, namespace: :founders)
    adapter = Onboarding::FoundersAdapter.new(session_store: session_store)
    user = FakeUser.new
    result = adapter.persist_step(actor: user, step: "startup", params: { company_name: "Acme" })
    assert result.success?
    assert_equal "Acme", user.startup_profile.attrs[:company_name]
  end

  test "confirm step marks onboarding_completed on user_profile" do
    session_store = Onboarding::SessionStore.new({}, namespace: :founders)
    adapter = Onboarding::FoundersAdapter.new(session_store: session_store)
    user = FakeUser.new
    result = adapter.persist_step(actor: user, step: "confirm", params: {})
    assert result.success?
    assert result.completed?
    # The adapter will attempt to update onboarding_completed on the profile
    assert_equal true, user.user_profile.attrs[:onboarding_completed]
  end

  test "guest merges into session and returns next_step" do
    session = {}
    session_store = Onboarding::SessionStore.new(session, namespace: :founders)
    adapter = Onboarding::FoundersAdapter.new(session_store: session_store)
    result = adapter.persist_step(actor: nil, step: "personal", params: { full_name: "Guest" })
    assert result.success?
    assert_equal "Guest", session_store.read(:full_name)
    assert_equal "startup", result.next_step
  end

  test "validation failure returns errors" do
    failing = FakeModel.new
    def failing.update(hash)
      false
    end
    def failing.errors
      OpenStruct.new(full_messages: [ "bad data" ])
    end

    user = FakeUser.new
    user.user_profile = failing

    session_store = Onboarding::SessionStore.new({}, namespace: :founders)
    adapter = Onboarding::FoundersAdapter.new(session_store: session_store)
    result = adapter.persist_step(actor: user, step: "personal", params: { full_name: "" })
    assert_not result.success?
    assert_includes result.errors, "bad data"
  end
end
