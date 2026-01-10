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
| Programs listing/detail | `Program` | ✅ | `title`, `slug`, `description`, `content`, `cover_image_url`, `category`, `active`, `start_date`, `end_date` | Cover image URL | ❌ | `active` flag only | Not wired to `/programs/:slug` route | ❌ | No SEO metadata, no rich text editor, slug editable. |
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
