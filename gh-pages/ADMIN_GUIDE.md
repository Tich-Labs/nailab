# Admin Guide (Consolidated)

This document consolidates the admin-focused docs (audit, backlog, views refactor, admin menu overview) into a single authoritative guide for editors and developers.

## Sources merged
- ADMIN_CMS_AUDIT.md
- ADMIN_IMPROVEMENTS_BACKLOG.md
- ADMIN_VIEWS_REFACTOR_PLAN.md
- admin-menu-overview.md

---

## ADMIN_CMS_AUDIT.md (original)

```markdown
# ADMIN_CMS_AUDIT — Nailab Marketing CMS (RailsAdmin)

## Purpose
Capture what marketing/public-site content RailsAdmin currently exposes, and point out the gaps relative to Nailab's marketing + mentorship MVP (resource library, startup directory, programs, etc.).

## Editable models today
- **HeroSlide** (hero carousel)
- **StaticPage** (home/about/pricing/contact via slug filters)
- **FocusArea**
- **Testimonial**
- **Partner**
- **Program**
- **Resource**
- **StartupProfile**

RailsAdmin also surfaces non-marketing tables under “Users & Auth” and “System” (User, UserProfile, MentorshipRequest, MentorshipConnection, Notification, Startup, JwtDenylist). The marketing models live in the `Marketing` navigation section per `config/initializers/rails_admin.rb`.

## Editable Marketing Content Matrix

| Page / Section | Model | Editable (Now) | Fields currently in schema | Media support? | Rich text? | Status workflow? | Preview? | SEO fields? | Gaps / risks |
|---|---|---|---|---|---|---|---|---|---|
| Home hero carousel | `HeroSlide` | ✅ | `title`, `subtitle`, `cta_text`, `cta_link`, `image_url`, `display_order`, `active` | Image URL string only | ❌ | `active` boolean only | Not configured (`show_in_app` <br> uses default RailsAdmin route) | ❌ | No validations, no preview target, no CTA requirement, `active` toggle is raw boolean, lack of hero image upload/preview, ordering is manual integer. |
| Home structured content | `StaticPage` (slug=`home`) | ✅ | `title`, `content`, `slug`, `structured_content` JSON | None | ❌ (plain text) | ❌ | `show_in_app` defaults to `/static_pages/:id` (not mapped to `/`) | ❌ | Slug editable (risk of breaking routes); structured content JSON is technical, no rich text view or block preview; no publish flag. |
| About page | `StaticPage` (slug=`about`) | ✅ | same as above | None | ❌ | ❌ | Preview route not tied to `/about` | ❌ | Same slug/preview risk. |
| Pricing page | `StaticPage` (slug=`pricing`) | ✅ | same | None | ❌ | ❌ | Not tied to `/pricing` | ❌ | Pricing layout editing is manual text blob. |
| Contact page | `StaticPage` (slug=`contact`) | ✅ | same | None | ❌ | ❌ | Not tied to `/contact` | ❌ | No guardrails/immediate preview; contact copy is raw text. |
| Focus areas | `FocusArea` | ✅ | `title`, `description`, `icon`, `display_order`, `active` | Icon URL string | ❌ | `active` only | Default RailsAdmin show | ❌ | No featured flag; ordering manual integer; icon field free-form string; no preview of home section. |
| Testimonials | `Testimonial` | ✅ | `quote`, `author_name`, `author_role`, `organization`, `photo_url`, `rating`, `display_order`, `active` | Photo URL string | ❌ | `active` only | Default show (not tied to home layout) | ❌ | No preview of homepage block; no slug/featured flag; PT field guard missing for public `author_name`. |
| Partners | `Partner` | ✅ | `name`, `logo_url`, `website_url`, `display_order`, `active` | Logo URL string | ❌ | `active` only | Default show | ❌ | Tier/order control missing; logos are URL-only. |
| Programs listing/detail | `Program` | ✅ | `title`, `slug`, `description`, `content`, `cover_image_url`, `category`, `active`, `start_date`, `end_date` | Cover image URL | ❌ | `active` flag only | Not wired to `/programs/:slug` route | ❌ | No SEO metadata, no rich text editor, no preview linking to `/programs/:slug`. |
| Resources & opportunities | `Resource` | ✅ | `title`, `slug`, `resource_type`, `description`, `content`, `url`, `published_at`, `active` | URL/file link | ❌ | `active` flag + `published_at` | Not wired to `/resources/:slug` (defaults to RailsAdmin) | ❌ | No author/tag metadata; resource_type free-text; no built-in upload/preview; gating/premium flag absent. |
| Startup directory | `StartupProfile` | ✅ | `startup_name`, `location`, `sector`, `stage`, `funding_stage`, `funding_raised`, `challenge_details`, `value_proposition`, `logo_url`, `mentorship_areas`, `active`, `website_url`, `preferred_mentorship_mode`, `team_size` | Logo URL string | ❌ | `active` boolean | Default show | ❌ | Visibility control limited to `active`; no slug; preview not tied to public `/startups`. |

**Notes:** All marketing models are currently CRUD-exposed via RailsAdmin but rely on plain text/JSON blobs, manual integer ordering, and simple booleans; there are no `show_in_app` preview helpers mapped to the public marketing routes, no SEO metadata tables, no draft/publish workflow, and slugs like `static_page.slug` or `program.slug` are fully editable without guardrails.

## Gaps vs MVP requirements
- **Resource library/opportunities hub:** RailsAdmin has `Resource` with `resource_type` and `content`, but there is no enforced categorization, premium flag, or file upload workflow, and filters/search are not configured. Preview links do not point to `/resources`.
- **Programs page:** Programs exist, but `category` is free-text, there is no SEO metadata, no rich-text editing (plain text `content`), and no preview linking to `/programs/:slug`.
- **Startup directory:** Startup profiles have `active` toggles but no gating/visibility controls beyond that, and there is no preview link to `/startups` or filters for sector/stage.
- **Static page slugs:** `home`, `about`, `pricing`, and `contact` slugs are editable, risking public route breaks if changed by accident. RailsAdmin does not currently lock or warn on slug edits.
- **Preview + CMS feel:** Aside from the static navigation links defined in `MARKETING_CONTENT_MENU`, there is no page-first ordering or preview actions. Forms are ungrouped (flat fields) and there is no consistent help text or guardrails for required hero/CTA info.

## Next verification steps
1. Inspect `config/initializers/rails_admin.rb` for per-model list/form configurations, preview routes, and read-only field settings. 
2. Review each marketing model in `app/models` to add validations and helper methods for preview URLs or slug immutability.
3. Determine whether ActiveStorage/ActionText is used anywhere (none currently) and whether image preview helpers can be added safely.
4. Sketch the desired page-first navigation order + quick preview links so RailsAdmin reflects the marketing site structure.

```

---

## ADMIN_IMPROVEMENTS_BACKLOG.md (original)

```markdown

# ADMIN_IMPROVEMENTS_BACKLOG — Nailab RailsAdmin CMS

**Instructions:**
- Please move completed items to the 'Completed Improvements' section below.
- Add links to issues/PRs for any in-progress or planned items.

## Completed Improvements
(Move completed 'Must have' or 'Should have' items here with date and reference)

Based on the current RailsAdmin configuration and Nailab marketing/mentorship MVP requirements, the following prioritized backlog uses MoSCoW categories. Each item includes a rough effort level (S=small, M=medium, L=large).

## Must have (MVP)

| Improvement | Notes | Effort |
|---|---|---|
| Lock system slugs (`home`, `about`, `pricing`, `contact`) | Make `StaticPage.slug` read-only for those records or validate that they cannot change after creation to protect public routes. | S |
| Page-first navigation & preview links | Surface static links for hero slides, home/about/pricing/contact, focus areas, testimonials, partners, programs, resources, startup directory; ensure `show_in_app` resolves to the correct marketing route so editors can preview before saving. | M |
| Hero/StaticPage form UX guardrails | Reorder fields (title → copy → CTA → media → status → SEO), add help text, require hero CTA text/link and image_url, and surface `active`/`published` toggles. | M |
| List view defaults for marketing models | Configure RailsAdmin lists to sort by `updated_at`/`display_order`, show key columns (title/slug/active/updated_at), and expose filters on `active` and category tags. | S |
| Preview URLs & show_in_app helpers | Map `StaticPage`, `Program`, `Resource`, `StartupProfile`, `HeroSlide` to their public routes (e.g., `/`, `/programs/:slug`, `/resources/:slug`, `/startups`). | S |

## Should have

| Improvement | Notes | Effort |
|---|---|---|
| SEO metadata fields | Add `meta_title`/`meta_description` (and OG image/url) for `StaticPage` and `Program` to align with marketing SEO requirements, expose them in RailsAdmin forms, and allow edits. | M |
| Status/publish workflow | Extend `StaticPage`/`Program`/`Resource` models with `published_at`/`published` flags (beyond the existing `active` boolean), so editors can draft before publishing; connect RailsAdmin actions. | M |
| Resource gating & categorization | Normalize `resource_type` into selectable options (article, toolkit, opportunity, etc.), add premium flag, and provide filters for type/published state in list view. | M |
| Startup directory visibility controls | Expose `active` flag, sector/stage filters, and default columns (name, location, sector) plus show_in_app links for `/startups`. | S |

## Could have

| Improvement | Notes | Effort |
|---|---|---|
| Role-based admin access | Add enums (e.g., `comms_admin`, `ops_admin`, `super_admin`) to `User`, restrict RailsAdmin sections accordingly (Marketing vs System). | L |
| Rich text / media previews | Integrate ActionText or at least preview helpers for `StaticPage.content` and hero/partner images via ActiveStorage so editors see formatted output. | L |
| Bulk feature/publish actions | Allow selecting multiple focus areas, testimonials, partners to toggle `active` or `featured` states from the list view. | M |

## Won’t have (for now)

| Improvement | Notes | Effort |
|---|---|---|
| Custom CMS outside RailsAdmin | Building a bespoke page-builder is out of scope; stick with RailsAdmin configuration. | – |
| Full marketing workflow (approval queue, audit logs) | RailsAdmin already ships with limited action history; heavy workflow tooling is deferred. | – |

Target implementation order: start with the Must-have list (locking slugs, nav/preview, hero/StaticPage UX, list defaults), then tackle Should-have SEO/status/categorization work before considering the Could-haves.

```

---

## ADMIN_VIEWS_REFACTOR_PLAN.md (original)

```markdown

# Admin Views Refactor Plan

## Status
- [ ] Standardize app/views/admin structure
- [ ] Remove legacy duplicates
- [ ] Document controller/view responsibilities
- [ ] Consolidate preview partials
- [ ] Standardize partial names
- [ ] Add header comments to controllers
- [ ] Run renderer checks and smoke tests

**Instructions:** Check off each item above as it is completed. Move completed steps to a 'Completed' section if desired.

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


```

---

## admin-menu-overview.md (original)

```markdown
# Admin panel menu overview (`/admin`)

This project uses **RailsAdmin** mounted at `/admin` (see `config/routes.rb`). The navigation is configured in `config/initializers/rails_admin.rb`.

## 1) Static menu: “Marketing layout”

These are **shortcuts** (static links) meant to make editing marketing/landing content fast.

- **Home • hero slides** (`/admin/hero_slide`)
  - Manages: `HeroSlide`
  - Responsible for: the hero carousel/slider content on the Home page (title/subtitle/image/CTA + display order + active).

- **Home • structured content** (`/admin/static_page?f[slug_eq]=home`)
  - Manages: `StaticPage` filtered to `slug=home`
  - Responsible for: JSON-driven home page sections stored in `static_pages.structured_content`.

- **Focus areas & support** (`/admin/focus_area`)
  - Manages: `FocusArea`
  - Responsible for: “focus areas” tiles/sections (title/description/icon/order/active).

- **Testimonials** (`/admin/testimonial`)
  - Manages: `Testimonial`
  - Responsible for: founder/partner quotes displayed on the site (author, role/org, quote, rating, order, active).

- **Partners** (`/admin/partner`)
  - Manages: `Partner`
  - Responsible for: partner logos + links shown on marketing pages (name/logo_url/website_url/order/active).

- **Programs** (`/admin/program`)
  - Manages: `Program`
  - Responsible for: programs/accelerators listing and detail content (title/slug/category/dates/description/content/active).

- **Resources** (`/admin/resource`)
  - Manages: `Resource`
  - Responsible for: resources listing (blog/knowledge hub/opportunity/event), including publish date, URL, active.

- **Startup directory** (`/admin/startup_profile`)
  - Manages: `StartupProfile`
  - Responsible for: the public “Startup directory” entries tied to users (startup_name, sector, stage, description, etc.).

- **About Nailab page** (`/admin/static_page?f[slug_eq]=about`)
  - Manages: `StaticPage` filtered to `slug=about`
  - Responsible for: About page HTML/content.

- **Pricing page** (`/admin/static_page?f[slug_eq]=pricing`)
  - Manages: `StaticPage` filtered to `slug=pricing`
  - Responsible for: Pricing page HTML/content.

- **Contact page** (`/admin/static_page?f[slug_eq]=contact`)
  - Manages: `StaticPage` filtered to `slug=contact`
  - Responsible for: Contact page HTML/content.

## 2) Model navigation groups

RailsAdmin also groups models into sections via `navigation_label`.

### Marketing

Configured with weights (order):

- **Landing + page content** (`StaticPage`, weight 0)
  - Stores page bodies (`content`) and structured JSON (`structured_content`).
  - Used by: Home/About/Pricing/Contact pages.

- **HeroSlide** (weight 1)
- **FocusArea** (weight 2)
- **Testimonial** (weight 3)
- **Partner** (weight 4)
- **Program** (weight 5)
- **Resource** (weight 6)
- **StartupProfile** (weight 7)

### Users & Auth

- **User**
  - Devise-authenticated accounts (email/password + JWT).
  - Owns: `user_profile` and `startup_profile`.

- **UserProfile**
  - Personal profile info for a user (bio, role, experience, mentorship preferences, visibility, etc.).

- **MentorshipRequest**
  - A founder requests mentorship from a mentor (both reference `User`).
  - Tracks: message + status (`pending`/etc.) + responded_at.

- **MentorshipConnection**
  - A confirmed relationship created from a `MentorshipRequest`.
  - Tracks: founder, mentor, request, and connection status.

### System

- **Notification**
  - In-app notifications for a user (title/message/link/read/metadata).

- **Startup**
  - A separate startup table (not the same as `StartupProfile`).
  - Likely used for internal/system lists rather than user-owned directory entries.

- **JwtDenylist**
  - Stores revoked JWTs for Devise-JWT (server-side token revocation).

## 3) What admin actions are available?

RailsAdmin enables these actions globally (see `config/initializers/rails_admin.rb`):

- dashboard, index, new, export, bulk_delete, show, edit, delete, show_in_app

```
