
# Nailab - Startup Mentorship Platform

A comprehensive Rails application connecting startups with experienced mentors through structured mentorship programs, resources, and support systems.

## Features (summary with users & journeys)



## Site Map (Visual Tree)

Documentation: https://tich-labs.github.io/nailab/

- **Authentication & Profiles**: Devise-based registration, confirmation, password reset, and role-specific registrations for `Founders`, `Mentors`, and `Admins`. Users complete role-based profiles (including `StartupProfile`) to access platform features. Journey: register → confirm email → complete profile → access portal.
- **Onboarding**: Multi-step onboarding for founders and mentors (personal → startup → professional → mentorship preferences). Journey: complete each onboarding step → receive onboarding notifications → be eligible for matches and programs.
- **Founder Portal**: Dashboard, startup profile management, opportunities, progress tracker, milestones, metrics, subscription & account settings. Journey: sign in → view dashboard → apply for opportunities → track progress.
- **Mentor Portal**: Mentor dashboard with availability, mentorship requests, conversations, session scheduling, and profile management. Journey: set availability → receive requests → accept/decline → host sessions.
- **Mentorship Requests & Matching**: Create/respond/accept/decline/reschedule mentorship requests with matching logic and admin oversight. Journey: founder requests mentorship → mentor responds → schedule session → follow-up.
- **Sessions & Scheduling**: Session booking, calendar integration, session join links and session records. Journey: schedule → join → record notes/outcomes.
- **Messaging & Conversations**: In-app threaded conversations between users (founder ↔ mentor) with message history. Journey: create conversation → send messages → follow up.
- **Support Ticketing**: `SupportTicket` and `SupportTicketReply` models with threaded admin replies via RailsAdmin. Journey: submit ticket → admin responds → resolve.
- **Content & Admin Management**: `RailsAdmin` used to manage pages, programs, resources, focus areas, logos and other content. Admins can moderate users, manage programs, and reply to support tickets.
- **Programs & Resources**: Program listings, program pages, and a resource library supporting attachments for guides, templates, and event resources. Journey: browse → view program → access resources.
- **Search & API**: Versioned `api/v1` endpoints (programs, resources, startup_profiles, mentor_profiles) and basic search on startup profiles for discovery. Journey: authenticate → search → fetch details.
- **Files & Media**: ActiveStorage for uploads (logos, hero images, resource images, profile photos). Admins and editors can upload content via direct uploads.
- **Notifications & Email**: ActionMailer-based emails and in-app notifications for onboarding, ticket updates, mentorship events and admin messages.
- **Analytics & Tracking**: Hooks for analytics events (onboarding_completed, etc.) to integrate with trackers. Journey: user completes actions → analytics recorded.
- **Security & Access Control**: CSRF protection, role-based access control, and user-scoped data throughout controllers and admin interfaces.
- **Payments & Subscriptions (billing)**: Pricing and subscription management scaffolding present; integrate Stripe or other providers for billing in production. Journey: choose plan → subscribe → manage billing.
- **Frontend stack**: Tailwind CSS, Hotwire (Turbo/Stimulus), and importmap-driven assets for a responsive UI.
- **Background jobs & Mailers**: App uses ActiveJob for async work and mail delivery (configure an adapter like Sidekiq or the built-in async adapter for development).
```
/        # Home — Nailab landing page (hero, sections, testimonials, partners, CTAs)
├── about        # About Nailab, mission, team, story
├── programs     # List of all programs
│   └── :slug    # Program detail page
├── resources    # Resource library (blogs, guides, etc.)
├── startups     # Startup directory
├── pricing      # Pricing and plans
├── contact      # Contact form/info
├── login        # Login page (Devise, styled)
├── signup       # Signup page (Devise, styled)
├── admin        # RailsAdmin dashboard
│   ├── support_tickets  # Admin support ticket management
│   └── ...              # Other admin interfaces
├── founder      # Founder portal
│   ├── dashboard        # Founder dashboard
│   ├── support          # Support ticket system
│   │   ├── tickets      # Create new tickets
│   │   └── tickets/:id  # View ticket conversations
│   ├── mentorship_requests
│   ├── sessions
│   ├── resources
│   ├── opportunities
│   ├── milestones
│   ├── monthly_metrics
│   ├── account
│   ├── subscription
│   └── profile
├── mentor       # Mentor portal (alias: mentor_portal)
│   ├── dashboard        # Mentor dashboard
│   ├── support          # Support ticket system
│   │   ├── tickets      # Create new tickets
│   │   └── tickets/:id  # View ticket conversations
│   ├── mentorship_requests
│   │   ├── :id/accept
│   │   ├── :id/decline
│   │   └── :id/reschedule
│   ├── conversations
│   │   └── messages
│   ├── schedule
│   ├── sessions
│   │   ├── :id/join
│   │   └── :id/add_to_calendar
│   ├── startups
│   ├── profile
│   ├── settings
│   └── logout
├── users        # Devise user auth endpoints
│   ├── sign_in
│   ├── sign_up
│   ├── password/new
│   └── ...
├── api          # API endpoints for frontend/mobile
│   └── v1
│       ├── sign_in
│       ├── sign_out
│       ├── sign_up
│       ├── me
│       ├── hero_slides
│       ├── partners
│       ├── testimonials
│       ├── programs
│       │   └── :slug
│       ├── resources
│       ├── startup_profiles
│       ├── mentor_profiles
│       ├── mentorship_requests
│       │   └── :id/respond
│       ├── matches
│       └── onboarding
│           ├── founder
│           └── mentor
└── up           # Health check endpoint
```


## Getting Started

### Prerequisites
- Ruby 3.2.3 (use `rbenv` / `rvm` to manage versions)
- Rails 8.1.1
- PostgreSQL (12+ recommended)
- Node.js 18+ and Yarn (or `npm`) for asset compilation

### Installation

1. Clone the repository
```bash
git clone git@github.com:Tich-Labs/nailab.git
cd nailab-rails
```

2. Install Ruby gems and JS packages
```bash
rbenv install 3.2.3    # optional: only if Ruby not installed
rbenv local 3.2.3
bundle install
yarn install --check-files
```

3. Configure credentials and environment variables

- If the project uses an `.env` helper file:
```bash
cp .env.example .env
# Edit .env to set any secrets and service credentials
```
- Ensure `RAILS_MASTER_KEY` (or `config/credentials.yml.enc`) is available in your environment for encrypted credentials.

4. Set up the database
```bash
rails db:create
rails db:migrate
rails db:seed
```

5. Start the development server (recommended)
```bash
bin/dev   # runs web and asset dev processes via Procfile.dev if present
# or
bundle exec rails server
```

Notes
- The repo includes `Procfile`/`Procfile.dev` and `render.yaml` for local multi-process workflows and Render deployment respectively. Use `bin/dev` or a Procfile runner to run web and background processes together.
- ActiveStorage is used for uploads (local disk in development). Configure storage service in `config/storage.yml` for production.
- Background jobs and mail delivery use `ActiveJob` — configure an adapter such as Sidekiq or use the default async adapter for local development.

### Key Dependencies

- **Rails 8.1.1**: Web framework
- **Devise**: Authentication
- **RailsAdmin**: Admin interface
- **Tailwind CSS**: Styling
- **PostgreSQL**: Database
- **Hotwire**: Real-time features
- **OmniAuth**: Social authentication

## Development

### Testing
```bash
rails test
```

### Code Quality
```bash
rubocop
brakeman
```

### Deployment
The application is configured for deployment on Render with included `render.yaml` configuration.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## License

[Add license information]
