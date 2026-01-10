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
