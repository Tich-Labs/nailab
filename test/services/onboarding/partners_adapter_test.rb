require "test_helper"

class PartnersAdapterTest < ActiveSupport::TestCase
  class FakePartner
    attr_reader :attrs
    def initialize(attrs = {})
      @attrs = attrs
    end

    def persisted?
      true
    end

    def errors
      OpenStruct.new(full_messages: [])
    end
  end

  test "guest persists to session for organization step" do
    session = {}
    session_store = Onboarding::SessionStore.new(session, namespace: :partners)
    adapter = Onboarding::PartnersAdapter.new(session_store: session_store)
    result = adapter.persist_step(actor: nil, step: "organization", params: { name: "PartnerCo" })
    assert result.success?
    assert_equal "PartnerCo", session_store.read(:name)
  end

  test "actor confirm creates Partner when model present" do
    # stub Partner model
    partner_class = Class.new do
      def self.create(attrs)
        obj = Object.new
        def obj.persisted?; true; end
        def obj.errors; OpenStruct.new(full_messages: []); end
        obj
      end
    end
    Object.const_set(:Partner, partner_class)

    begin
      session = {}
      session_store = Onboarding::SessionStore.new(session, namespace: :partners)
      adapter = Onboarding::PartnersAdapter.new(session_store: session_store)
      user = OpenStruct.new
      result = adapter.persist_step(actor: user, step: "confirm", params: { name: "P" })
      assert result.success?
      assert result.completed?
    ensure
      Object.send(:remove_const, :Partner) if Object.const_defined?(:Partner)
    end
  end

  test "actor non-final step stores in session and advances" do
    session = {}
    session_store = Onboarding::SessionStore.new(session, namespace: :partners)
    adapter = Onboarding::PartnersAdapter.new(session_store: session_store)
    user = OpenStruct.new
    result = adapter.persist_step(actor: user, step: "type_and_contact", params: { contact_email: "a@b" })
    assert result.success?
    assert_equal "a@b", session_store.read(:contact_email)
    assert_equal "focus_and_collab", result.next_step
  end
end
