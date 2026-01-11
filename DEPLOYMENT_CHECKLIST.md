# Deployment checklist

Use this checklist before running migrations or performing production deploys that touch the database.

1. Backup production database
   - Take a full DB snapshot or export (platform-specific). Ensure backups are stored and verified.

2. Review migrations and seeds
   - Inspect new migrations for destructive actions (drop column/table, data deletes).
   - Avoid running `db:reset` or `db:setup` in production.

3. Run migrations on production only
   - Deploy code, then run migrations in the production environment (do not point local `rails` to production DB).
   - Example (Heroku): `heroku run rake db:migrate --app YOUR_APP_NAME`

4. Run any necessary data migrations carefully
   - Prefer non-blocking, idempotent data migrations.
   - Test in staging before production.

5. Verify application and DB health
   - Check logs, run smoke tests, and confirm critical endpoints.

6. Rollback plan
   - Have a tested rollback plan (DB restore + code rollback) and know the steps and timing.

7. Emergency override (use sparingly)
   - If you must run a blocked destructive Rake task in production, set the env var `ALLOW_PROD_DB_CHANGE=1` for that command.
   - Example: `ALLOW_PROD_DB_CHANGE=1 heroku run rake db:drop && heroku run rake db:setup --app YOUR_APP_NAME`

8. Post-deploy checks
   - Run any post-deploy verification scripts and monitor app metrics.

---
Keep this checklist updated with platform-specific commands and contacts for DB restore owners.
