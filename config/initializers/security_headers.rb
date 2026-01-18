# frozen_string_literal: true

# Security Headers Configuration
# Add basic security headers to protect against common web vulnerabilities

Rails.application.configure do
  # Basic security headers that apply to all environments
  config.action_dispatch.default_headers = {
    # === CLICKJACKING PROTECTION ===
    "X-Frame-Options" => "DENY",
    # Prevents your site from being embedded in iframes by malicious sites

    # === MIME SNIFFING PROTECTION ===
    "X-Content-Type-Options" => "nosniff",
    # Prevents browsers from trying to guess file types

    # === XSS PROTECTION ===
    "X-XSS-Protection" => "1; mode=block",
    # Enables XSS filtering in older browsers (modern browsers rely on CSP)

    # === CONTENT SECURITY POLICY WITH NONCE ===
    # Basic CSP to prevent XSS and code injection with nonce support
    "Content-Security-Policy" => lambda {
      # Generate a new nonce for each request
      nonce = SecureRandom.hex(16)

      base_csp = [
        "default-src 'self'",
        "script-src 'self' 'unsafe-inline' 'unsafe-eval' https://cdn.jsdelivr.net https://unpkg.com",
        "style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://unpkg.com",
        "img-src 'self' data: https:",
        "font-src 'self'",
        "connect-src 'self' https://cdn.jsdelivr.net",
        "frame-ancestors 'none'",
        "base-uri 'self'",
        "form-action 'self'",
        "worker-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://unpkg.com",
        "manifest-src 'self'"
      ].join("; ")

      # Set nonce in response header for views to use
      csp_with_nonce = base_csp.gsub("script-src 'self'", "script-src 'self' 'unsafe-inline' #{nonce}")
                         .gsub("style-src 'self'", "style-src 'self' 'unsafe-inline' #{nonce}")

      {
        "Content-Security-Policy" => csp_with_nonce,
        "X-Content-Security-Policy-Nonce" => nonce
      }
    }
  }
end

# Production-specific security headers
if Rails.env.production?
  Rails.application.configure do
    # === HTTP STRICT TRANSPORT SECURITY (HSTS) ===
    # Enforce HTTPS for 1 year including subdomains
    # Only add this when you have valid SSL certificate
    config.action_dispatch.default_headers["Strict-Transport-Security"] =
      "max-age=31536000; includeSubDomains; preload"

    # === REFERRER POLICY ===
    # Control how much referrer information is sent
    config.action_dispatch.default_headers["Referrer-Policy"] =
      "strict-origin-when-cross-origin"
  end
end

# Development-specific headers (more permissive for development)
if Rails.env.development?
  Rails.application.configure do
    # Relax CSP in development for debugging
    config.action_dispatch.default_headers["Content-Security-Policy"] = [
      "default-src 'self' 'unsafe-inline' 'unsafe-eval'",
      "script-src 'self' 'unsafe-inline' 'unsafe-eval' https://cdn.jsdelivr.net",
      "style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net",
      "img-src 'self' data: http: https:",
      "font-src 'self'",
      "connect-src 'self' https://cdn.jsdelivr.net ws: wss:",
      "frame-ancestors 'none'"
    ].join("; ")
  end
end
