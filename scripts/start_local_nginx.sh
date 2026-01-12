#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/start_local_nginx.sh
# Requires: `openssl` and `nginx` installed. Runs nginx with a minimal config that
# terminates TLS on 443 and proxies to http://127.0.0.1:3000.

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
NGINX_CONF="$ROOT_DIR/deploy/nginx/nginx_local.conf"
SSL_DIR="$ROOT_DIR/deploy/nginx/ssl"

if ! command -v nginx >/dev/null 2>&1; then
  echo "Error: nginx is not installed (command 'nginx' not found)." >&2
  echo "Install it, then re-run this script." >&2
  echo "  Ubuntu/Mint/Debian: sudo apt-get update && sudo apt-get install -y nginx" >&2
  exit 127
fi

if ! command -v openssl >/dev/null 2>&1; then
  echo "Error: openssl is not installed (command 'openssl' not found)." >&2
  echo "Install it, then re-run this script." >&2
  echo "  Ubuntu/Mint/Debian: sudo apt-get update && sudo apt-get install -y openssl" >&2
  exit 127
fi

mkdir -p "$SSL_DIR"

CERT="$SSL_DIR/local.crt"
KEY="$SSL_DIR/local.key"

if [ ! -f "$CERT" ] || [ ! -f "$KEY" ]; then
  echo "Generating self-signed certificate for localhost..."
  openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
    -subj "/CN=localhost" \
    -keyout "$KEY" -out "$CERT"
fi

TMP_CONF="$(mktemp --suffix=_nginx_local.conf)"

# Replace placeholders in the template
sed \
  -e "s|__SSL_CERT_PATH__|$CERT|g" \
  -e "s|__SSL_KEY_PATH__|$KEY|g" \
  "$NGINX_CONF" > "$TMP_CONF"

echo "Starting nginx with config: $TMP_CONF"
nginx -c "$TMP_CONF"

echo "nginx started."
echo "- HTTPS: https://localhost:8443/"
echo "- HTTP redirect: http://localhost:8080/"
echo "To stop: nginx -s stop -c $TMP_CONF"
