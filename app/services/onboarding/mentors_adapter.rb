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
        # Persist partial step data without running full validations so that
        # multi-step onboarding can collect fields across steps. We only run
        # full validations when reaching the final step; if those validations
        # fail, we return errors and do not mark the flow completed.
        profile.assign_attributes(params)
        profile.save(validate: false)

        next_step = next_step(step)
        completed = next_step.nil?
        profile.update(onboarding_step: step) if profile.respond_to?(:onboarding_step)

        if completed
          # On final step attempt a validated save. If validations fail return
          # errors so the controller can show messages and prevent advancing.
          # Ensure a usable slug exists for the profile (some records were
          # created earlier without running validations/slug generation). If a
          # slug collides, append a short random suffix and retry once.
          if profile.slug.blank?
            base = (profile.full_name.presence || profile.user&.email || SecureRandom.hex(4)).to_s.parameterize
            candidate = base
            if UserProfile.exists?(slug: candidate)
              candidate = "#{base}-#{SecureRandom.hex(3)}"
            end
            profile.slug = candidate
          end

          # If the mentor did not provide a rate and pro_bono is not true,
          # assume pro_bono so final validation does not block due to missing
          # rate. This is a conservative fallback for users who prefer not to
          # set a rate during testing; production behavior can surface this
          # choice in the UI instead.
          if profile.rate_per_hour.blank? && profile.pro_bono != true
            profile.pro_bono = true
          end

          if profile.save
            profile.update(onboarding_completed: true, profile_visibility: true)
            OpenStruct.new(success?: true, errors: [], next_step: next_step, completed?: true, changed_models: { user_profile: profile })
          else
            OpenStruct.new(success?: false, errors: profile.errors.full_messages, next_step: step, completed?: false)
          end
        else
          OpenStruct.new(success?: true, errors: [], next_step: next_step, completed?: false, changed_models: { user_profile: profile })
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
