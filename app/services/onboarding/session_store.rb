module Onboarding
  # Simple session wrapper for namespaced onboarding data
  class SessionStore
    def initialize(session, namespace:)
      @session = session || {}
      @namespace = "onboarding_#{namespace}".to_sym
      @session[@namespace] ||= {}
    end

    def read(key)
      @session[@namespace][key.to_s]
    end

    def write(key, value)
      @session[@namespace][key.to_s] = value
    end

    def merge!(hash)
      @session[@namespace].merge!(hash.stringify_keys)
    end

    def to_h
      @session[@namespace]
    end
  end
end
