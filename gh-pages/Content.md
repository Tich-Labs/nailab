# Marketing Content Map (RailsAdmin)

This document details all marketing content managed via the backend admin (RailsAdmin), including the path, content type, and fields for each section. This enables full CRUD (and archive) management of all marketing content from the backend.

---

## Home • Hero slides
- **Path:** `/admin/hero_slide`
- **Content:** Homepage hero slides
- **Fields:**
  - Title
  - Subtitle
  - CTA text
  - CTA link
  - Image (ActiveStorage)
  - Display order
  - Active (boolean)

## Home • Structured content
- **Path:** `/admin/static_page?f[slug_eq]=home`
- **Content:** Structured blocks for homepage
- **Fields:**
  - Title
  - Slug (should be 'home')
  - Content (HTML/Markdown)
  - Structured content (JSON/blocks)

## About page
- **Path:** `/admin/static_page?f[slug_eq]=about`
- **Content:** About page content
- **Fields:**
  - Title
  - Slug (should be 'about')
  - Content (HTML/Markdown)
  - Structured content (JSON/blocks)

## Programs
- **Path:** `/admin/program`
- **Content:** List and manage all programs
- **Fields:**
  - Name/Title
  - Description
  - Content (detailed info)
  - Category
  - Cover image URL
  - Links (detail page, external, etc.)

## Resources
- **Path:** `/admin/resource`
- **Content:** Resource links, downloads, or articles
- **Fields:**
  - Title
  - Description
  - URL/File
  - Category/Type

## Startup directory
- **Path:** `/admin/startup_profile`
- **Content:** Directory of startups
- **Fields:**
  - Startup name
  - Description
  - Stage
  - Target market
  - Value proposition
  - Profile visibility (boolean)
  - Founder info (linked)

## Pricing page
- **Path:** `/admin/static_page?f[slug_eq]=pricing`
- **Content:** Pricing page content
- **Fields:**
  - Title
  - Slug (should be 'pricing')
  - Content (HTML/Markdown)
  - Structured content (plans, features)

## Contact page
- **Path:** `/admin/static_page?f[slug_eq]=contact`
- **Content:** Contact page content
- **Fields:**
  - Title
  - Slug (should be 'contact')
  - Content (HTML/Markdown)
  - Address, phone, email
  - Contact form settings

## Partners
- **Path:** `/admin/partner`
- **Content:** Partner organizations
- **Fields:**
  - Name
  - Logo URL/Image
  - Website URL
  - Description

## Testimonials
- **Path:** `/admin/testimonial`
- **Content:** Testimonials
- **Fields:**
  - Quote
  - Name
  - Title/Role
  - Company
  - Image URL
  - Company URL

## Focus areas
- **Path:** `/admin/focus_area`
- **Content:** Key focus sectors
- **Fields:**
  - Title
  - Description

---

**Note:** All of the above content is fully CRUD-manageable (and archivable) from the backend admin interface. For any additional fields or custom logic, see the corresponding model and RailsAdmin config.
