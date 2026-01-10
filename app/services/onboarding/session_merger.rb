module Onboarding
  class SessionMerger
    # Merge namespaced onboarding session data into an existing user's profiles.
    # Returns true if any data was merged, false otherwise.
    def self.merge(user, session)
      return false unless user && session

      fs = Onboarding::SessionStore.new(session, namespace: :founders)
      ms = Onboarding::SessionStore.new(session, namespace: :mentors)
      ps = Onboarding::SessionStore.new(session, namespace: :partners)

      merged = false

      if fs.to_h.present?
        up_attrs = fs.to_h.slice("full_name", "phone", "country", "city", "email") rescue fs.to_h
        sp_attrs = fs.to_h.except(*up_attrs.keys) rescue fs.to_h

        # build or update user_profile
        if user.respond_to?(:user_profile) && (user.user_profile || user.respond_to?(:build_user_profile))
          user_profile = user.user_profile || user.build_user_profile
          user_profile.assign_attributes(up_attrs.merge(role: "founder"))
          user_profile.save if user_profile.respond_to?(:changed?) ? user_profile.changed? : true
        end

        # build or update startup_profile
        if user.respond_to?(:startup_profile) && (user.startup_profile || user.respond_to?(:build_startup_profile))
          startup_profile = user.startup_profile || user.build_startup_profile
          startup_profile.assign_attributes(sp_attrs)
          startup_profile.save if startup_profile.respond_to?(:changed?) ? startup_profile.changed? : true
        end

        merged = true
      end

      if ms.to_h.present?
        if user.respond_to?(:user_profile) && (user.user_profile || user.respond_to?(:build_user_profile))
          user_profile = user.user_profile || user.build_user_profile
          user_profile.assign_attributes(ms.to_h.merge(role: "mentor"))
          user_profile.save if user_profile.respond_to?(:changed?) ? user_profile.changed? : true
        end
        merged = true
      end

      if ps.to_h.present?
        if defined?(Partner) && Partner.respond_to?(:create)
          Partner.create(ps.to_h)
          merged = true
        end
      end

      if merged
        # auto-confirm the user so they can continue in-browser
        if user.respond_to?(:confirm) && !user.respond_to?(:confirmed?)
          begin
            user.confirm
          rescue
            # ignore confirm failures in merge
          end
        elsif user.respond_to?(:confirmed_at) && user.confirmed_at.nil?
          begin
            user.update_column(:confirmed_at, Time.current)
          rescue
            # ignore update failures
          end
        end

        session.delete(:onboarding_founders)
        session.delete(:onboarding_mentors)
        session.delete(:onboarding_partners)
      end

      merged
    end
  end
end
