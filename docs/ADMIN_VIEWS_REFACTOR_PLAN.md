# Admin Views Refactor Plan

Goal: standardize `app/views/admin` structure, remove legacy duplicates, and document controller/view responsibilities.

Canonical structure (recommended):
- `app/views/admin/homepages/` - dashboard/sections index (single page)
- `app/views/admin/homepage/` - per-homepage-section pages and their preview partials (hero, impact_network, focus_areas)
- `app/views/admin/<resource>/` - resourceful admin pages (focus_areas, logos, testimonials) with partials `_form.html.erb`, `_rows.html.erb`, `_preview.html.erb`, `_item.html.erb`.

Planned concrete moves/deletes (safe, incremental):
1. Delete legacy/duplicate files (already removed or to remove):
   - `app/views/admin/homepage/focus_areas_preview.html.erb` (duplicate) - already deleted.
   - `app/views/admin/homepage/_focus_areas_preview_items.html.erb` (legacy) - removed.
2. Consolidate preview partials (canonical locations):
   - `app/views/admin/homepage/focus_areas/_preview.html.erb` — canonical preview for Focus Areas.
   - `app/views/admin/homepage/impact_network/_preview.html.erb` — canonical preview for Impact Network (used by `Admin::LogosController` JSON responses).
   - `app/views/admin/homepage/testimonials/_preview.html.erb` — canonical preview for Testimonials.
3. Standardize partial names across resources: rename any nonstandard partials to `_preview.html.erb`, `_rows.html.erb`, `_form.html.erb` as needed.
4. Add header comments to controllers to document responsibilities (done for `Admin::HomepageController` and `Admin::HomepagesController`).
5. Run renderer checks and smoke tests to verify no missing template errors.

Verification commands (run locally):
```
bin/rails runner 'puts ApplicationController.renderer.render(file: Rails.root.join("app","views","admin","homepages","edit.html.erb"), layout: false)'
bin/rails runner 'puts ApplicationController.renderer.render(partial: "admin/homepage/focus_areas/preview", locals: { focus_areas: FocusArea.where(active: true).order(:display_order) })'
bin/rails runner 'puts ApplicationController.renderer.render(partial: "admin/homepage/impact_network/preview", locals: { logos: Logo.where(active: true).order(:display_order) })'
bin/rails runner 'puts ApplicationController.renderer.render(partial: "admin/homepage/testimonials/preview", locals: { testimonials: Testimonial.where(active: true).order(:display_order) })'
```

Rollback plan:
- Keep changes small and commit each file deletion/move in its own commit.
- If a render error occurs, restore the deleted file from git history and search for references to the missing partial.

Notes:
- Routes are intentionally mixed: resourceful controllers (`Admin::LogosController`, `Admin::FocusAreasController`) provide JSON endpoints and CRUD actions, while `Admin::HomepageController` hosts the per-section admin pages (UI). This is acceptable but should be documented (comments added).

