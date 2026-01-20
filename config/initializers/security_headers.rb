# frozen_string_literal: true

# Security Headers Configuration
# Add basic security headers to protect against common web vulnerabilities

Rails.application.configure do
  # Basic security headers that apply to all environments
  config.action_dispatch.default_headers = {
    # === CLICKJACKING PROTECTION ===
    # Prevents your site from being embedded in iframes by malicious sites
    "X-Frame-Options" => "DENY",

    # === MIME SNIFFING PROTECTION ===
    # Prevents browsers from trying to guess file types
    "X-Content-Type-Options" => "nosniff",

    # === XSS PROTECTION ===
    # Enables XSS filtering in older browsers (modern browsers rely on CSP)
    "X-XSS-Protection" => "1; mode=block",

    # === CONTENT SECURITY POLICY ===
    # Basic CSP to prevent XSS and code injection. The header value must be
    # a string; returning a Hash (or leaving a Proc object in the header)
    # caused to Proc inspection string to show up as a directive name.
    # Evaluate CSP at boot and store as a string to avoid embedding Proc objects
    # in header values which can appear as "#<Proc:0x...>" in the header.
    "Content-Security-Policy" => [
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
    # Relax CSP in development for debugging and letter_opener
    config.action_dispatch.default_headers["Content-Security-Policy"] = [
      "default-src 'self' 'unsafe-inline' 'unsafe-eval'",
      "script-src 'self' 'unsafe-inline' 'unsafe-eval' https://cdn.jsdelivr.net https://unpkg.com",
      "style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://unpkg.com",
      "img-src 'self' data: http: https:",
      "font-src 'self'",
      "connect-src 'self' https://cdn.jsdelivr.net ws: wss:",
      "frame-ancestors 'self'"  # Allow letter_opener iframe in development
    ].join("; ")
  end
end
