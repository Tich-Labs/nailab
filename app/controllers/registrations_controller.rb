  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :role)
  end
class RegistrationsController < Devise::RegistrationsController
  def create
    super do |user|
      # Use Onboarding::SessionStore namespaces where adapters write data
      fs = Onboarding::SessionStore.new(session, namespace: :founders)
      ms = Onboarding::SessionStore.new(session, namespace: :mentors)
      ps = Onboarding::SessionStore.new(session, namespace: :partners)

      # Attach founder data if present
      if fs.to_h.present?
        # Ensure the user record is persisted so associations get a user_id
        unless user.persisted?
          saved = user.save
          unless saved
            Rails.logger.error("Registrations#create: could not persist user before creating profiles: ")
            Rails.logger.error(user.errors.full_messages.join("; "))
            next
          end
        end

        up_attrs = fs.to_h.slice("full_name", "phone", "country", "city", "email") rescue fs.to_h
        sp_attrs = fs.to_h.except(*up_attrs.keys) rescue fs.to_h
        user_profile = user.create_user_profile(up_attrs.merge(role: "founder"))
        unless user_profile&.persisted?
          Rails.logger.error("Registrations#create: failed to create user_profile: #{user_profile&.errors&.full_messages}")
        end
        startup_profile = user.create_startup_profile(sp_attrs)
        unless startup_profile&.persisted?
          Rails.logger.error("Registrations#create: failed to create startup_profile: #{startup_profile&.errors&.full_messages}")
        end

        # Notify admins about new founder submission for review
        begin
          payload = { user_profile: user_profile&.attributes, startup_profile: startup_profile&.attributes }
          Notifications::OnboardingNotifier.notify_admin_of_submission(user: user, role: :founders, payload: payload)
        rescue => e
          Rails.logger.error("Registrations#create: failed to notify admin of submission: #{e.message}")
        end
      end

      # Attach mentor data if present
      if ms.to_h.present?
        user_profile = user.build_user_profile(ms.to_h.merge(role: "mentor"))
        user_profile.save
      end

      # Attach partner interest (store as Partner if model exists)
      if ps.to_h.present?
        if defined?(Partner)
          Partner.create(ps.to_h)
        end
      end

      # If onboarding data existed, auto-confirm mentors/partners and sign them in.
        # Founders should NOT be auto-confirmed — they must wait for approval email.
        if ms.to_h.present? || ps.to_h.present?
          flash[:notice] = "Welcome to Nailab! 🎉 Your founder account has been created successfully. Please check your email for confirmation and next steps to complete your profile setup."
        end
        # Sign in the user (bypass Devise confirmable gate if we just confirmed)
        sign_in(resource_name, user) unless user_signed_in?
        elsif fs.to_h.present?
        # Founders: leave unconfirmed in production and show a pending notice
        flash[:notice] = "Thanks for signing up. We'll review your application and send an approval email shortly."
      end

      # Clear onboarding session namespaces
      session.delete(:onboarding_founders)
      session.delete(:onboarding_mentors)
      session.delete(:onboarding_partners)

      # In development/test, if the user is not confirmed, generate a temporary
      # confirmation token and show a clickable dev confirmation link so testers
      # can confirm via browser without requiring email delivery.
      if (Rails.env.development? || Rails.env.test?) && !user.confirmed?
        raw, enc = Devise.token_generator.generate(User, :confirmation_token)
        user.confirmation_token = enc
        user.confirmation_sent_at = Time.current
        user.save(validate: false)
        link = Rails.application.routes.url_helpers.dev_confirm_email_path(raw)
        flash.now[:notice] = "Dev confirmation link: <a href='#{link}'>Confirm email</a>".html_safe
        Rails.logger.info("Dev confirmation link for user=#{user.email}: #{link}")
       end
  end

  # Page shown to users whose sign up is pending manual approval/confirmation
  def pending
    render :pending
  end
  protected

  def after_sign_up_path_for(resource)
    case resource.role
    when :mentor
      mentor_root_path
    when :founder
      founder_onboarding_path
    else
      root_path
    end
  end

  def after_sign_in_path_for(resource)
    case resource.role
    when :mentor
      mentor_root_path
    when :founder
      founder_onboarding_path
    else
       root_path
    end
end
