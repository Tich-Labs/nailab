require "ostruct"

module Onboarding
  # Adapter for founder onboarding steps. Persists to UserProfile and StartupProfile
  # or to session for guest flows. Returns OpenStruct service results.
  class FoundersAdapter
    STEPS = %w[personal startup additional invite_cofounders invite_team professional mentorship confirm].freeze

    def initialize(session_store:)
      @session_store = session_store
    end

    # Persist a single onboarding step.
    # actor: User or nil, step: String, params: ActionController::Parameters or Hash
    def persist_step(actor:, step:, params:)
      return OpenStruct.new(success?: false, errors: [ "invalid_step" ]) unless STEPS.include?(step)

      if actor
        case step
        when "personal"
          profile = actor.user_profile || actor.build_user_profile
          success = profile.update(params)
          build_result(success, profile, step)
        when "startup", "professional", "mentorship"
          startup = actor.startup_profile || actor.build_startup_profile
          # Set onboarding_step so only current step's validations run
          startup.onboarding_step = step if startup.respond_to?(:onboarding_step)
          success = startup.update(params)
          build_result(success, startup, step)
        when "additional"
          # Allow founders to add additional startups (creates Startup records)
          # Params expected to include keys matching Startup model
          begin
            new_startup = actor.startups.create(
              startup_name: params[:startup_name],
              description: params[:description],
              website_url: params[:website_url],
              year_founded: params[:year_founded],
              team_size: params[:team_size],
              value_proposition: params[:value_proposition],
              target_market: params[:target_market]
            )
            if params[:logo].present? && new_startup.respond_to?(:logo)
              new_startup.logo.attach(params[:logo]) rescue nil
            end
            build_result(new_startup.persisted?, new_startup, step)
          rescue => e
            OpenStruct.new(success?: false, errors: [ e.message ], next_step: step, completed?: false)
          end
        when "confirm"
          # Validate all fields before marking onboarding as complete
          profile = actor.user_profile || actor.build_user_profile
          startup = actor.startup_profile || actor.build_startup_profile

          # Remove onboarding_step so all validations run
          profile.onboarding_step = nil if profile.respond_to?(:onboarding_step)
          startup.onboarding_step = nil if startup.respond_to?(:onboarding_step)

          valid_profile = profile.valid?
          valid_startup = startup.valid?

          if valid_profile && valid_startup
            success = profile.update(onboarding_completed: true)
            build_result(success, profile, step, completed: true)
          else
            errors = []
            errors += profile.errors.full_messages unless valid_profile
            errors += startup.errors.full_messages unless valid_startup
            OpenStruct.new(success?: false, errors: errors, next_step: step, completed?: false)
          end
        end
      else
        # Guest flow: merge into session store
        @session_store.merge!(params.to_h)
        next_step = next_step(step)
        completed = next_step.nil?
        OpenStruct.new(success?: true, errors: [], next_step: next_step, completed?: completed, changed_models: { session: @session_store.to_h })
      end
    rescue => e
      OpenStruct.new(success?: false, errors: [ e.message ])
    end

    # Basic validation helpers for steps. Returns array of error messages (empty when valid)
    def validate_step(step, params)
      errs = []
      case step
      when "personal"
        errs << "full_name required" if params[:full_name].to_s.strip.empty?
      when "startup"
        errs << "startup_name required" if params[:startup_name].to_s.strip.empty?
      end
      errs
    end

    # Finalize persistent models for an actor (mark onboarding completed and ensure slug)
    def finalize(actor)
      return OpenStruct.new(success?: false, errors: [ "no_actor" ]) unless actor
      profile = actor.user_profile || actor.build_user_profile
      startup = actor.startup_profile || actor.build_startup_profile

      # mark completed
      ok1 = profile.update(onboarding_completed: true)

      # ensure startup slug exists and is unique if model supports slug
      if defined?(StartupProfile) && startup.respond_to?(:slug)
        base = (startup.attrs && startup.attrs[:startup_name]) || startup.try(:startup_name) || "startup"
        slug = base.to_s.parameterize
        candidate = slug
        counter = 2
        while StartupProfile.exists?(slug: candidate)
          candidate = "#{slug}-#{counter}"
          counter += 1
        end
        startup.update(slug: candidate)
      end

      if ok1
        OpenStruct.new(success?: true, errors: [], completed?: true, changed_models: { user_profile: profile, startup_profile: startup })
      else
        OpenStruct.new(success?: false, errors: profile.errors.full_messages)
      end
    end

    def next_step(current_step)
      idx = STEPS.index(current_step)
      STEPS[idx + 1] if idx && idx < STEPS.length - 1
    end

    private

    def build_result(success, model, step, completed: nil)
      if success
          # Only set `onboarding_step` on models that actually support it.
          if model.respond_to?(:onboarding_step) && model.onboarding_step != step
            model.update(onboarding_step: step)
          end
        next_s = next_step(step)
        completed_flag = completed.nil? ? next_s.nil? : completed
        # if finishing, ensure user_profile is marked completed
        if completed_flag && model.respond_to?(:user_id)
          # no-op: leave model-specific finalization to caller if needed
        end
        OpenStruct.new(success?: true, errors: [], next_step: next_s, completed?: completed_flag, changed_models: { model.class.name.underscore.to_sym => model })
      else
        errs = model.respond_to?(:errors) ? model.errors.full_messages : [ "validation_failed" ]
        OpenStruct.new(success?: false, errors: errs, next_step: step, completed?: false)
      end
    end
  end
end
