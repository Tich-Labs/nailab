Local TLS reverse-proxy for Nailab (development)

This provides a minimal nginx configuration and helper script to terminate TLS
locally and proxy requests to the Rails dev server on `http://127.0.0.1:3000`.

Requirements
- `nginx` installed
- `openssl` installed

Start
1. Ensure your Rails server is running locally:

```bash
bin/rails s -b 127.0.0.1 -p 3000
```

2. Start nginx via the helper (creates a self-signed cert):

```bash
./scripts/start_local_nginx.sh
```

3. Open https://localhost:8443/ (your browser will warn about the self-signed cert).

Stopping nginx

```bash
nginx -s stop
```

Notes
- The script writes a generated cert/key to `deploy/nginx/ssl/local.crt` and
  `deploy/nginx/ssl/local.key`.
- If you prefer to use your own certificate, replace `__SSL_CERT_PATH__` and
  `__SSL_KEY_PATH__` in `deploy/nginx/nginx_local.conf` or set the files in
  `deploy/nginx/ssl/`.
