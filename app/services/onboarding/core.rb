require "ostruct"

module Onboarding
  # Orchestrates multi-step onboarding for a given role (mentor/founder/partner)
  class Core
    # call(actor: User or nil, role: :mentors, step: String, params: Hash, session: Hash)
    def self.call(actor:, role:, step:, params:, session: {}, **opts)
      adapter_class = adapter_for(role)
      return OpenStruct.new(success?: false, errors: [ "Unknown role: #{role}" ]) unless adapter_class

      session_store = SessionStore.new(session, namespace: role)
      adapter = adapter_class.new(session_store: session_store)

      result = adapter.persist_step(actor: actor, step: step, params: params)

      # Ensure result responds to success?/errors/next_step/completed/changed_models
      if result.respond_to?(:success?)
        result
      else
        OpenStruct.new(success?: false, errors: [ "Adapter did not return ServiceResult" ])
      end
    end

    def self.adapter_for(role)
      case role.to_s
      when "mentors", "mentor"
        Onboarding::MentorsAdapter
      when "founders", "founder"
        Onboarding::FoundersAdapter
      when "partners", "partner"
        Onboarding::PartnersAdapter
      else
        nil
      end
    end
  end
end
