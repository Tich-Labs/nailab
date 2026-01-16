
# Nailab - Startup Mentorship Platform

Documentation: [Documentation](https://tich-labs.github.io/nailab/)

A comprehensive Rails application connecting startups with experienced mentors through structured mentorship programs, resources, and support systems.

## Features

- **Authentication**: Devise-based sign up, sign in, and password management. **Users**: Founders, Mentors, Admins. **Journey**: register → confirm email → complete profile.
- **Onboarding**: Multi-step onboarding for founders, mentors, and partners. **Users**: Founders, Mentors, Partners. **Journey**: complete personal → startup → professional steps → set preferences.
- **Founder Portal**: Dashboard, opportunities, progress tracker, startup profile, account & subscription management. **Users**: Founders. **Journey**: log in → view dashboard → apply for opportunities → track progress.
- **Mentor Portal**: Mentor dashboard, availability, mentorship requests, sessions, conversations. **Users**: Mentors. **Journey**: set availability → receive requests → accept/decline → host sessions.
- **Mentorship Requests & Matching**: Create/respond/accept/decline/reschedule requests and match mentors to founders. **Users**: Founders, Mentors, Admins. **Journey**: request mentorship → mentor responds → schedule session.
- **Sessions & Scheduling**: Session join links, calendar integration, session management. **Users**: Founders, Mentors. **Journey**: schedule session → join session → follow-up notes.
- **Support Ticketing System**: `SupportTicket` and `SupportTicketReply` models with RailsAdmin integration and threaded conversations. **Users**: Founders, Mentors, Admins. **Journey**: submit ticket → admin replies → resolve ticket.
- **Admin Dashboard**: RailsAdmin for managing users, content, programs, and support tickets. **Users**: Admins. **Journey**: review content → moderate users → respond to tickets.
- **Programs & Resources**: Program listings and resource library (guides, templates, event resources). **Users**: Public, Founders, Mentors. **Journey**: browse programs → view details → access resources.
- **Startup Profiles & Directory**: Create and manage startup profiles, searchable directory. **Users**: Founders, Mentors, Public. **Journey**: create profile → update details → get discovered.
- **Payments & Subscriptions**: Pricing pages and subscription management for paid plans. **Users**: Founders (customers). **Journey**: choose plan → subscribe → manage billing.
- **API Endpoints**: Versioned `api/v1` endpoints supporting frontend and mobile clients. **Users**: Frontend/mobile developers. **Journey**: authenticate → fetch program/resource data → perform actions.
- **Security & Access Control**: CSRF protection, role-based access limits, and user-scoped data. **Users**: All. **Journey**: access resources according to role and permissions.
- **Frontend & UX**: Tailwind CSS, Hotwire, and importmap-driven assets for a responsive, performant UI. **Users**: Developers and end users. **Journey**: responsive UI, fast interactions.

## Site Map (Visual Tree)

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

5. Start the development server
```bash
bundle exec rails server
```

Notes
- The repo includes `Procfile`/`Procfile.dev` and `render.yaml` for local multi-process workflows and Render deployment respectively. Use `bin/dev` or a Procfile runner if you prefer to run web and background processes together.

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
bundler-audit
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
