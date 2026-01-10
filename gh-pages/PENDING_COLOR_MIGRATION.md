# Pending: Color token migration

**Status:** pending

## Summary
The frontend has introduced centralized Tailwind tokens `nailab-purple` (`#913F98`) and `nailab-teal` (`#50C6D8`) to standardize brand colors across the app. Some documentation and non-view files still reference legacy utilities like `teal-600`, `teal-700`, `purple-600`, and `purple-700` or hard-coded hex values. These references should be reviewed and migrated to tokenized classes (for example: `bg-nailab-teal`, `text-nailab-teal`, `bg-nailab-purple`, `text-nailab-purple`) where appropriate.

## Action items
- Scan docs and non-view source files for `teal-*` / `purple-*` utilities and inline hexes, excluding generated build files (e.g., `app/assets/builds/*`) and logs.
- Replace occurrences in docs, helpers, and source templates that are not part of the compiled CSS with tokenized classes for clarity.
- Do not edit generated build artifacts or log files; instead, rebuild Tailwind after source changes so compiled CSS reflects tokens.
- Add a short note in changelog/release notes documenting the new tokens and the reason for migration.

## Notes
- This file was created from an automated audit step; to keep the `docs/ADMIN_CMS_AUDIT.md` minimal and stable, we add this separate pending note rather than editing generated or archived docs in-place.
- When ready to execute replacements across docs, run a targeted `grep` and `apply_patch` or scripted replacement, then run the Tailwind build script to regenerate `app/assets/builds/application.css`.
