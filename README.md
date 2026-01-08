
# Nailab - Startup Mentorship Platform

A comprehensive Rails application connecting startups with experienced mentors through structured mentorship programs, resources, and support systems.

## Features

## 🚦 Implementation Status

See [docs/FEATURE_IMPLEMENTATION_AUDIT.md](docs/FEATURE_IMPLEMENTATION_AUDIT.md) for a detailed, up-to-date audit of all features, their status (implemented, partial, missing), and evidence. This file is updated regularly as new features are completed.

**Summary (as of Jan 2026):**
- ✅ Implemented: 49
- 🟡 Partial: 12
- ❌ Missing: 8

For missing or incomplete features, see [docs/MISSING_COMPONENTS_LIST.md](docs/MISSING_COMPONENTS_LIST.md).

For planned improvements and admin UI work, see [docs/ADMIN_IMPROVEMENTS_BACKLOG.md](docs/ADMIN_IMPROVEMENTS_BACKLOG.md) and [docs/ADMIN_VIEWS_REFACTOR_PLAN.md](docs/ADMIN_VIEWS_REFACTOR_PLAN.md).

For mentorship matching logic and roadmap, see [docs/MENTORSHIP_MATCHING_PLAN.md](docs/MENTORSHIP_MATCHING_PLAN.md).

### 🎯 Core Functionality

### 💬 Support System
- **Support Ticketing**: Full conversation system between users and admins
- **Admin Dashboard**: RailsAdmin interface for ticket management
- **User Portals**: Separate interfaces for founders and mentors
- **Conversation Threading**: Complete message history and status tracking

### 🔐 Authentication & Authorization
- **Devise Integration**: Complete user authentication system
- **Role-Based Access**: Founder and mentor user types
- **Social Sign-in**: LinkedIn OAuth integration
- **Email Confirmation**: Account verification system

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

## Support Ticketing System

The application includes a comprehensive support ticketing system that enables full conversations between users and administrators:

### For Users (Founders & Mentors)
- **Create Support Tickets**: Submit issues with subject and detailed description
- **View Ticket History**: See all their support tickets with status indicators
- **Conversation Threading**: View complete conversation history with admin replies
- **Reply to Tickets**: Continue conversations with support staff
- **Status Tracking**: Monitor ticket progress (Open, In Progress, Resolved, Closed)

### For Administrators
- **RailsAdmin Integration**: Manage tickets through the admin dashboard
- **Conversation View**: See full ticket conversations with user/admin distinction
- **Inline Replies**: Reply directly from the admin interface
- **Status Management**: Update ticket status and track resolution
- **User Context**: View user information and ticket history

### Technical Implementation
- **Models**: `SupportTicket` and `SupportTicketReply` with polymorphic associations
- **Admin Interface**: Custom RailsAdmin configuration with conversation display
- **User Interfaces**: Separate controllers and views for founder and mentor portals
- **Security**: CSRF protection and user-specific access control
- **Styling**: Tailwind CSS with consistent design across admin and user interfaces

## Getting Started

### Prerequisites
- Ruby 3.2.3
- Rails 8.1.1
- PostgreSQL
- Node.js & Yarn (for asset compilation)

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd nailab-rails
```

2. Install dependencies
```bash
bundle install
yarn install
```

3. Set up the database
```bash
rails db:create
rails db:migrate
rails db:seed
```

4. Configure environment variables
```bash
# Copy and configure .env file
cp .env.example .env
```

5. Start the development server
```bash
bundle exec rails server
```

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
