
# Nailab

Welcome to the Nailab Rails application! This project powers the Nailab platform, providing resources, programs, and a startup ecosystem.

---

## Table of Contents

- [Nailab](#nailab)
  - [Table of Contents](#table-of-contents)
  - [Project Overview](#project-overview)
  - [Tech Stack](#tech-stack)
  - [Features \& Functionalities](#features--functionalities)
  - [Site Map](#site-map)
  - [Setup](#setup)
  - [Usage](#usage)
  - [Testing](#testing)
  - [Deployment](#deployment)
  - [Contributing](#contributing)
  - [License](#license)

---

## Project Overview

Nailab is a platform for startups, mentors, and partners to connect, learn, and grow.

---

## Tech Stack

- **Ruby on Rails** — Main backend framework
- **PostgreSQL** — Database
- **Redis** — Caching and background jobs
- **Sidekiq** — Background job processing
- **Devise** — Authentication
- **RailsAdmin** — Admin dashboard
- **Webpacker** / **ESBuild** — Asset bundling
- **Tailwind CSS** — Styling
- **StimulusJS** — Frontend interactivity
- **Docker** — Containerization (optional)
- **RSpec** / **Minitest** — Testing frameworks

---

## Features & Functionalities

- User authentication and management (sign up, login, password reset)
- Admin dashboard for managing users, programs, and content
- Program listing and detail pages
- Resource library (blogs, guides, etc.)
- Startup directory and profiles
- Mentor onboarding and profiles
- Partner onboarding
- API endpoints for frontend/mobile apps
- Health check endpoint (`/up`)
- Responsive design with Tailwind CSS
- Background job processing with Sidekiq
- Email notifications and support ticketing

---

---

## Site Map

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

---

## Setup

1. Clone the repository:

 ```bash
 git clone https://github.com/your-org/nailab-rails.git
 cd nailab-rails
 ```

1. Install dependencies:

 ```bash
 bundle install
 yarn install # or npm install
 ```

1. Set up the database:

 ```bash
 rails db:setup
 ```

1. Start the Rails server:

 ```bash
 rails server
 ```

---

## Usage

- Visit `http://localhost:3000` in your browser.
- Log in or sign up to access user features.
- Admins can access `/admin` for dashboard features.

---

## Testing

Run all tests:

```bash
rails test
# or, if using RSpec:
bundle exec rspec
```

---

## Deployment

1. Ensure all environment variables are set (see `.env.example`).
2. Run migrations:

 ```bash
 rails db:migrate RAILS_ENV=production
 ```

1. Precompile assets:

 ```bash
 rails assets:precompile
 ```

1. Start the server in production mode.

---

## Contributing

1. Fork the repository
2. Create a new branch (`git checkout -b feature/your-feature`)
3. Commit your changes
4. Push to your fork and open a Pull Request

---

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
