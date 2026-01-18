# frozen_string_literal: true

# Rack::Attack configuration for rate limiting and security
# This protects against brute force attacks, DDoS, and abuse

Rails.application.configure do
  config.middleware.use Rack::Attack
end

class Rack::Attack
  # === BASIC RATE LIMITS ===

  # Throttle login attempts by IP address
  throttle("logins/ip", limit: 5, period: 15.minutes) do |req|
    req.path == "/users/sign_in" && req.post?
  end

  # Throttle password reset attempts by IP address
  throttle("password_resets/ip", limit: 3, period: 1.hour) do |req|
    req.path == "/users/password" && req.post?
  end

  # Throttle registration attempts by IP address
  throttle("registrations/ip", limit: 5, period: 1.hour) do |req|
    req.path == "/users" && req.post?
  end

  # Throttle email confirmation attempts
  throttle("confirmations/ip", limit: 5, period: 1.hour) do |req|
    req.path == "/users/confirmation" && req.post?
  end

  # === API RATE LIMITS ===

  # Throttle API requests by IP address
  throttle("api/ip", limit: 100, period: 1.hour) do |req|
    req.path.start_with?("/api/") && req.user_agent.present?
  end

  # Throttle authentication API calls
  throttle("api/auth", limit: 20, period: 1.hour) do |req|
    (req.path == "/api/v1/auth/sign_in" ||
     req.path == "/api/v1/auth/refresh") && req.post?
  end

  # === ADVANCED PROTECTION ===

  # Block suspicious user agents
  blocklist("bad bots") do |req|
    bad_bots = %w[
      sqlmap
      nmap
      nikto
      masscan
      zap
      burp
      w3af
      nikto
      sqlninja
      wapiti
      hydra
    ]

    req.user_agent&.downcase&.match?(/#{bad_bots.join('|')}/)
  end

  # Block requests without proper user agent (likely bots)
  blocklist("no ua") do |req|
    req.path.start_with?("/api/") && req.user_agent.blank?
  end

  # === LOGGING AND MONITORING ===

  # Log blocked requests for monitoring
  self.throttled_responder = lambda do |req|
    # Log throttling attempts for security monitoring
    Rails.logger.warn "[Rack::Attack] Throttled request: #{req.ip} #{req.path} #{req.user_agent}"

    # Return rate limit response
    [
      429,
      { "Content-Type" => "application/json" },
      [ {
        "error": "Rate limit exceeded",
        "message": "Too many requests. Please try again later.",
        "retry_after": "#{2.minutes.to_i}"
      }.to_json ]
    ]
  end

  # Custom response for blocked requests
  self.blocklisted_responder = lambda do |req|
    # Log blocked requests for security monitoring
    Rails.logger.warn "[Rack::Attack] Blocked request: #{req.ip} #{req.path} #{req.user_agent}"

    [
      403,
      { "Content-Type" => "application/json" },
      [ {
        "error": "Access denied",
        "message": "Your request has been blocked for security reasons."
      }.to_json ]
    ]
  end

  # Custom response for blocked requests
  self.blocklisted_responder = lambda do |req|
    request = Rack::Request.new(env)

    # Log blocked requests for security monitoring
    Rails.logger.warn "[Rack::Attack] Blocked request: #{req.ip} #{req.path} #{req.user_agent}"

    [
      403,
      { "Content-Type" => "application/json" },
      [ {
        "error": "Access denied",
        "message": "Your request has been blocked for security reasons."
      }.to_json ]
    ]
  end

  # === SAFELISTS ===

  # Allow local requests during development
  safelist("allow localhost") do |req|
    req.ip == "127.0.0.1" || req.ip == "::1" || Rails.env.development?
  end
end

# Cache mechanism for Rack::Attack (important for performance)
# Use Redis in production when available (supports `increment`),
# otherwise fall back to an in-memory store which also supports `increment`.
unless Rails.env.test?
  if ENV["REDIS_URL"].present?
    Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(url: ENV["REDIS_URL"])
  else
    Rails.logger.warn "Rack::Attack: REDIS_URL not set; using MemoryStore for rate limiting"
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
  end
end
