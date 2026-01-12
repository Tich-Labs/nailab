require "ostruct"

module Onboarding
  # Minimal adapter implementing mentor onboarding persistence rules.
  class MentorsAdapter
    STEPS = %w[basic_details work_experience mentorship_focus mentorship_style availability review].freeze

    def initialize(session_store:)
      @session_store = session_store
    end

    # Persist a single step. Returns OpenStruct with success?, errors, next_step, completed?
    def persist_step(actor:, step:, params:)
      return OpenStruct.new(success?: false, errors: [ "invalid_step" ]) unless STEPS.include?(step)

      if actor
        profile = actor.user_profile || actor.build_user_profile
        success = profile.update(params)
        if success
          next_step = next_step(step)
          completed = next_step.nil?
          profile.update(onboarding_step: step) if profile.respond_to?(:onboarding_step)
          if completed
            profile.update(onboarding_completed: true, profile_visibility: true)
          end
          OpenStruct.new(success?: true, errors: [], next_step: next_step, completed?: completed, changed_models: { user_profile: profile })
        else
          OpenStruct.new(success?: false, errors: profile.errors.full_messages, next_step: step, completed?: false)
        end
      else
        # Guest flow: store partial data in session and advance
        @session_store.merge!(params.to_h)
        next_step = next_step(step)
        completed = next_step.nil?
        OpenStruct.new(success?: true, errors: [], next_step: next_step, completed?: completed, changed_models: { session: @session_store.to_h })
      end
    end

    def next_step(current_step)
      idx = STEPS.index(current_step)
      STEPS[idx + 1] if idx && idx < STEPS.length - 1
    end
  end
end
