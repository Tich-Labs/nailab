# ADMIN_IMPROVEMENTS_BACKLOG — Nailab RailsAdmin CMS

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
