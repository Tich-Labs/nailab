# ✅ NAILAB PLATFORM — MASTER CHECKLIST (Rails 8)

Tracks progress of the rebuild from Wagtail/Django into Rails, aligned to MVP → Alpha → Beta phases.

**Status Legend:**

- 🔴 MVP-Critical  
- 🟠 MVP-High Priority  
- ⚪ Nice-to-have  
- [x] Completed  
- [ ] Pending  

---

## 1. CORE SETUP

- [x] 🔴 Rails 8 API app created
- [x] 🔴 Git repo initialized
- [x] 🔴 Wagtail repo reference added
- [x] 🔴 Copilot + Checklist files (`README_FOR_COPILOT.md`, `CHECKLIST.md`)

---

## 2. AUTHENTICATION & USERS

- [x] 🔴 Devise installed
- [x] 🔴 JWT auth with `devise-jwt`
- [x] 🔴 Google OAuth via OmniAuth
- [ ] ⚪ LinkedIn OAuth
- [x] 🔴 User profile fields (bio, photo, sector, etc.)
- [x] 🔴 Admin toggle (`role` field or enum)
- [ ] 🔴 Profile visibility settings
- [ ] 🟠 Onboarding wizard (mentor/startup flow)

---

## 3. MODELS & CONTENT TYPES

### Core Models  

- [x] 🟠 Startup  
- [x] 🟠 Mentor (expanded with detailed profile fields)
- [x] 🟠 BlogPost (ActionText)  
- [x] 🟠 TemplateGuide (ActiveStorage)  
- [x] 🟠 Opportunity  
- [x] 🟠 Event  

### MVP-Specific Models  

- [x] 🔴 MentorshipRequest  
- [x] 🟠 Testimonial  
- [x] 🟠 Program  
- [x] 🟠 NavigationItem  
- [x] 🟠 MentorApplication  
- [x] 🟠 MentorshipSession  
- [x] 🟠 Mentor (expanded with detailed profile fields: experience, industries, approach, etc.)
- [ ] 🔴 Message  
- [ ] 🔴 Notification  
- [ ] 🟠 SiteSetting (editable text, URLs)  
- [ ] 🟠 Tags / Categories  

---

## 4. ADMIN / CMS (AVO)

- [x] 🔴 Avo admin panel installed
- [x] 🔴 Devise protection for Avo
- [x] 🔴 Models registered (testimonial, program, navigation_item, mentor with detailed fields)
- [ ] 🟠 Custom Avo dashboard
- [ ] 🟠 Toggle mentor/startup approvals
- [ ] 🟠 Editable content blocks (static pages, footer)
- [ ] ⚪ SEO fields per page (via SiteSetting)

---

## 5. UI / STYLING (TAILWIND)

- [x] 🟠 Tailwind CSS setup + Propshaft fix
- [x] 🟠 Gotham font + Nailab brand colors
- [x] 🟠 Styled layouts (navbar, footer)
- [x] 🟠 Styled Devise pages
- [x] 🟠 Startup / Mentor / Resource cards (mentor profiles with detailed info)
- [x] 🟠 Pagination / Search filters
- [x] 🟠 Testimonials grid
- [x] 🟠 Programs index/show pages
- [ ] ⚪ Dark mode toggle

---

## 6. SEEDS & VALIDATIONS

- [x] 🟠 Sample data for all models
- [x] 🔴 Seeded mentors & requests (4+ with detailed profiles)
- [x] 🟠 Seeded mentor applications (2+)
- [x] 🔴 Model validations added (including mentor profile validations)
- [x] 🟠 Seeded testimonials (3+)
- [x] 🟠 Seeded programs (3+)
- [x] 🟠 Seeded navigation items
- [ ] 🟠 File upload testing (TemplateGuide)
- [ ] 🟠 ActionText rendering test

---

## 7. MENTORSHIP FLOW

- [x] 🔴 MentorshipRequest (one-time/ongoing)
- [x] 🔴 Mentor type selection (form step)
- [x] 🔴 Mentor request form
- [x] 🔴 Admin approval toggle
- [x] 🔴 Dashboard showing user requests
- [x] 🔴 Mentor availability toggle
- [x] 🟠 Mentor application system
- [x] 🟠 MentorshipSession tracking
- [ ] 🔴 Accept/decline flow
- [ ] 🟠 Feedback form (notes per session)

---

## 8. MATCHING & SEARCH

- [x] 🔴 Basic match logic (sector, stage)
- [x] 🟠 Relevance scoring
- [x] 🔴 Public startup directory
- [x] 🟠 Filter/sort options
- [ ] ⚪ Featured success stories

---

## 9. MESSAGING & NOTIFICATIONS

- [ ] 🔴 Message model
- [ ] 🔴 Notification model
- [ ] 🔴 In-app notification UI
- [ ] ⚪ ActionCable real-time updates
- [ ] ⚪ Email digest system

---

## 10. SUBSCRIPTIONS

- [ ] 🔴 Stripe (or M-Pesa via API)
- [ ] 🔴 Subscription tiers (Free/Premium)
- [ ] 🔴 Premium content gating
- [ ] 🟠 Invoicing
- [ ] ⚪ Free trial option

---

## 11. RESOURCE HUB

- [x] 🟠 BlogPost / TemplateGuide
- [x] 🟠 Unified Resources Hub page (/resources)
- [x] 🟠 Tabbed/filtered UI for all resource types
- [x] 🟠 Responsive card grid with partials
- [ ] 🟠 Tags / Categories
- [ ] 🟠 Resource filtering
- [ ] 🟠 Premium-only flag
- [ ] ⚪ Bookmark/save feature

---

## 12. DASHBOARDS

- [x] 🔴 User dashboard (mentorship requests)
- [ ] 🔴 Mentor dashboard (incoming requests, sessions)
- [ ] 🔴 Startup dashboard (metrics, progress)
- [ ] 🟠 Reminder system (update metrics, schedule sessions)
- [ ] ⚪ Visual graphs

---

## 13. HOMEPAGE MANAGEMENT

- [x] 🔴 HomepageSection model with enum + rich text
- [x] 🔴 Dynamic homepage rendering
- [x] 🔴 Avo resource for homepage sections
- [x] 🔴 Seed data for homepage sections
- [x] 🔴 About snapshot section added
- [x] 🟠 Testimonials section added
- [x] 🟠 Focus areas section added

---

## 13.5 NAVIGATION SYSTEM

- [x] 🟠 NavigationItem model with enum location
- [x] 🟠 Dynamic navbar/footer rendering
- [x] 🟠 Avo resource for navigation items
- [x] 🟠 Seeded primary and footer items

---

- [x] 🔴 Dockerfile created
- [x] 🔴 GitHub Actions CI/CD
- [ ] 🔴 Deploy to Render / Fly.io
- [ ] 🔴 ENV secrets (OAuth, storage, keys)
- [ ] ⚪ docker-compose for local dev

---

## 15. CLOUD SERVICES

- [ ] 🔴 Object Storage  
  - MVP: Render Disk  
  - Future: S3-compatible (e.g. DigitalOcean Spaces)

- [ ] 🟠 Redis (cache, background jobs)
- [ ] 🟠 Sidekiq (queues)
- [ ] 🟠 Email service (SendGrid)

---

## 16. FUTURE PHASES (Alpha / Beta)

- [ ] 🟠 Dashboard analytics + reminders
- [ ] 🟠 Mentor suggestion improvements
- [ ] ⚪ Booking calendar
- [ ] ⚪ Group messaging
- [ ] ⚪ Partner dashboard
- [ ] ⚪ Feedback surveys
- [ ] ⚪ Community features (posts/forums)

---

✅ **MVP STATUS: ~97% COMPLETE**

### Current focus

- Full mentorship sessions  
- Messaging & notifications  
- Subscriptions (Stripe)  
- Advanced dashboards  
- UI polish + testing  
- Production deployment  
