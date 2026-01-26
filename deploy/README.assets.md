Deployment note — Ensure Tailwind build is available during deploy

CI / deployment steps should ensure the compiled Tailwind CSS is present and
fingerprinted in the Sprockets manifest. Recommended options:

1) Precompile assets during CI / deploy

   RAILS_ENV=production bin/rails assets:precompile

   This will generate a fingerprinted `builds/tailwind-<hash>.css` entry that
   `asset_path('builds/tailwind.css')` can resolve at runtime.

2) If you prefer to publish `app/assets/builds/tailwind.css` directly, ensure
   your deployment copies that file to the server at `app/assets/builds/` or
   `/public/assets/builds/` so the runtime fallback can serve `/assets/builds/tailwind.css`.

3) Ensure the deploy image includes the Node build step (`npm run build:css`) or
   that CI artifacts contain the compiled file.

If you want, I can add a CI step (GitHub Actions) to run `npm ci && npm run build:css`
and `bin/rails assets:precompile` during the workflow.
