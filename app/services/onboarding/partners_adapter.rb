require "ostruct"

module Onboarding
  # Adapter for partner onboarding. Session-first; optionally persists Partner on final step.
  class PartnersAdapter
    STEPS = %w[organization type_and_contact focus_and_collab confirm].freeze

    def initialize(session_store:)
      @session_store = session_store
    end

    # Persist a single onboarding step.
    # actor: User or nil, step: String, params: ActionController::Parameters or Hash
    def persist_step(actor:, step:, params:)
      return OpenStruct.new(success?: false, errors: [ "invalid_step" ]) unless STEPS.include?(step)

      # Map step keys into session-friendly keys
      mapped = map_step_params(step, params)

      if actor
        # If actor provided, optionally persist to Partner model on confirm
        if step == "confirm"
          begin
            if defined?(Partner)
              partner_attrs = (@session_store.to_h || {}).merge(mapped)
              partner = if actor.respond_to?(:partners)
                actor.partners.create(partner_attrs)
              else
                Partner.create(partner_attrs)
              end
              if partner.persisted?
                OpenStruct.new(success?: true, errors: [], next_step: nil, completed?: true, changed_models: { partner: partner })
              else
                OpenStruct.new(success?: false, errors: partner.errors.full_messages, next_step: step, completed?: false)
              end
            else
              # No Partner model available; fallback to storing in session
              @session_store.merge!(mapped)
              OpenStruct.new(success?: true, errors: [], next_step: nil, completed?: true, changed_models: { session: @session_store.to_h })
            end
          rescue => e
            OpenStruct.new(success?: false, errors: [ e.message ], next_step: step, completed?: false)
          end
        else
          # For non-final steps, persist to session for actor as well to allow preview before persist
          @session_store.merge!(mapped)
          next_s = next_step(step)
          OpenStruct.new(success?: true, errors: [], next_step: next_s, completed?: next_s.nil?, changed_models: { session: @session_store.to_h })
        end
      else
        # Guest flow: always store in session
        @session_store.merge!(mapped)
        next_s = next_step(step)
        completed = next_s.nil?
        OpenStruct.new(success?: true, errors: [], next_step: next_s, completed?: completed, changed_models: { session: @session_store.to_h })
      end
    end

    # Validate params for a given step; returns array of error messages
    def validate_step(step, params)
      errs = []
      case step
      when "organization"
        errs << "organization_name required" if params[:organization_name].to_s.strip.empty?
      end
      errs
    end

    # Finalize partner onboarding: optionally persist to Partner model
    def finalize(session_data)
      data = session_data || @session_store.to_h
      if defined?(Partner)
        partner = Partner.create(data)
        if partner.persisted?
          OpenStruct.new(success?: true, errors: [], completed?: true, changed_models: { partner: partner })
        else
          OpenStruct.new(success?: false, errors: partner.errors.full_messages)
        end
      else
        OpenStruct.new(success?: true, errors: [], completed?: true, changed_models: { session: data })
      end
    end

    def next_step(current_step)
      idx = STEPS.index(current_step)
      STEPS[idx + 1] if idx && idx < STEPS.length - 1
    end

    private

    # Normalize params for storage; keep as simple hash
    def map_step_params(step, params)
      params.respond_to?(:to_h) ? params.to_h : params
    end
  end
end
