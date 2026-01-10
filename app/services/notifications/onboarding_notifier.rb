module Notifications
  class OnboardingNotifier
    # Enqueue admin notification about a new onboarding submission.
    # Parameters:
    # - user: User or nil
    # - role: String or Symbol
    # - payload: Hash
    def self.notify_admin_of_submission(user:, role:, payload: {})
      if defined?(Jobs::AdminNotificationJob)
        Jobs::AdminNotificationJob.perform_later(user&.id, role.to_s, payload)
      else
        Rails.logger.info("[OnboardingNotifier] admin notification queued: user=#{user&.id} role=#{role} payload=#{payload.inspect}")
      end
    end

    # Enqueue welcome email (or similar) to user after onboarding completion.
    def self.notify_user_on_completion(user:, role:, payload: {})
      if defined?(Jobs::SendWelcomeEmailJob)
        # prefer sending via the Jobs namespace if available
        Jobs::SendWelcomeEmailJob.perform_later(user.id, role.to_s, payload)
      elsif defined?(SendWelcomeEmailJob)
        SendWelcomeEmailJob.perform_later(user.id, role.to_s, payload)
      else
        Rails.logger.info("[OnboardingNotifier] would send welcome email to user=#{user&.id} role=#{role} payload=#{payload.inspect}")
      end
    end
  end
end
