module Jobs
  class SendWelcomeEmailJob < ApplicationJob
    queue_as :default

    # user_id: Integer, role: String/Symbol, payload: Hash (optional)
    def perform(user_id, role = nil, payload = {})
      user = User.find_by(id: user_id)
      unless user
        Rails.logger.warn "SendWelcomeEmailJob: user not found id=#{user_id}"
        return
      end

      if defined?(OnboardingMailer)
        OnboardingMailer.with(user: user, role: role, payload: payload).welcome_email.deliver_now
      else
        Rails.logger.info "SendWelcomeEmailJob: would send welcome email to user=#{user.id} role=#{role} payload=#{payload.inspect}"
      end
    end
  end
end
