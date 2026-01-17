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

    # === CONTENT SECURITY POLICY ===
    # Basic CSP to prevent XSS and code injection
    "Content-Security-Policy" => [
      "default-src 'self'",              # Only allow resources from same origin
      "script-src 'self' 'unsafe-inline'", # Allow inline scripts for Hotwire/Turbo
      "style-src 'self' 'unsafe-inline'", # Allow inline styles for Tailwind
      "img-src 'self' data: https:",     # Allow images from same origin and https
      "font-src 'self'",                # Allow fonts from same origin
      "connect-src 'self'",              # Only connect to same origin
      "frame-ancestors 'none'",         # Prevent clickjacking (modern alternative to X-Frame-Options)
      "base-uri 'self'",                 # Restrict base URI
      "form-action 'self'"               # Restrict form submissions
    ].join("; ")
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
      "script-src 'self' 'unsafe-inline' 'unsafe-eval'",
      "style-src 'self' 'unsafe-inline'",
      "img-src 'self' data: http: https:",
      "font-src 'self'",
      "connect-src 'self' ws: wss:",
      "frame-ancestors 'none'"
    ].join("; ")
  end
end
