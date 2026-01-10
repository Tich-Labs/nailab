require "test_helper"

class MentorsAdapterTest < ActiveSupport::TestCase
  class FakeProfile
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
    attr_accessor :user_profile
    def initialize
      @user_profile = FakeProfile.new
    end

    def build_user_profile
      @user_profile = FakeProfile.new
    end
  end

  test "guest persists to session" do
    session_store = Onboarding::SessionStore.new({}, namespace: :mentors)
    adapter = Onboarding::MentorsAdapter.new(session_store: session_store)
    result = adapter.persist_step(actor: nil, step: "basic_details", params: { full_name: "Ada" })
    assert result.success?
    assert_equal "Ada", session_store.read(:full_name)
  end

  test "actor persists to user_profile" do
    session_store = Onboarding::SessionStore.new({}, namespace: :mentors)
    adapter = Onboarding::MentorsAdapter.new(session_store: session_store)
    user = FakeUser.new
    result = adapter.persist_step(actor: user, step: "basic_details", params: { full_name: "Turing" })
    assert result.success?
    assert_equal "Turing", user.user_profile.attrs[:full_name]
  end

  test "actor completes onboarding on final step and sets onboarding_completed" do
    session_store = Onboarding::SessionStore.new({}, namespace: :mentors)
    adapter = Onboarding::MentorsAdapter.new(session_store: session_store)
    user = FakeUser.new
    # simulate completing the last step
    result = adapter.persist_step(actor: user, step: "review", params: { full_name: "Grace" })
    assert result.success?
    assert result.completed?
    # ensure profile was updated and flagged completed
    assert_equal "Grace", user.user_profile.attrs[:full_name]
  end

  test "validation failure returns errors" do
    # create a failing profile
    failing = FakeProfile.new
    def failing.update(hash)
      false
    end
    def failing.errors
      OpenStruct.new(full_messages: [ "name missing" ])
    end

    user = FakeUser.new
    user.user_profile = failing

    session_store = Onboarding::SessionStore.new({}, namespace: :mentors)
    adapter = Onboarding::MentorsAdapter.new(session_store: session_store)
    result = adapter.persist_step(actor: user, step: "basic_details", params: { full_name: "" })
    assert_not result.success?
    assert_includes result.errors, "name missing"
  end
end
