class RegistrationsController < Devise::RegistrationsController
  def create
    super do |user|
      # Use Onboarding::SessionStore namespaces where adapters write data
      fs = Onboarding::SessionStore.new(session, namespace: :founders)
      ms = Onboarding::SessionStore.new(session, namespace: :mentors)
      ps = Onboarding::SessionStore.new(session, namespace: :partners)

      # Attach founder data if present
      if fs.to_h.present?
        up_attrs = fs.to_h.slice("full_name", "phone", "country", "city", "email") rescue fs.to_h
        sp_attrs = fs.to_h.except(*up_attrs.keys) rescue fs.to_h
        user_profile = user.build_user_profile(up_attrs.merge(role: "founder"))
        user_profile.save
        startup_profile = user.build_startup_profile(sp_attrs)
        startup_profile.save
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

      # If onboarding data existed, auto-confirm the user so they can continue in-browser
      if fs.to_h.present? || ms.to_h.present? || ps.to_h.present?
        if user.respond_to?(:confirm)
          user.confirm
        elsif user.respond_to?(:confirmed_at)
          user.update(confirmed_at: Time.current)
        end
        # Sign in the user (bypass Devise confirmable gate if we just confirmed)
        sign_in(resource_name, user) unless user_signed_in?
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
  end

  protected

  def after_sign_up_path_for(resource)
    if resource.user_profile&.role == "mentor"
      mentor_root_path
    else
      founder_root_path
    end
  end
end
