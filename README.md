# 🚀 Nailab Platform

A mentorship and startup support platform built with **Ruby on Rails 8**, designed to empower African founders with expert guidance, growth resources, and funding opportunities. This is a full rebuild of the original Wagtail/Django backend, now modernized using Rails and Avo for admin UX.

---

## 🧠 Purpose

Nailab supports African startups by connecting them with:

- 🌍 **Expert mentors**
- 💰 **Funding & opportunities**
- 📚 **Practical toolkits & learning resources**
- 👩🏽‍💼 **A network of like-minded founders**

The platform matches founders to mentors, offers a startup directory, provides content and downloads, and powers mentorship session tracking — all from one dynamic dashboard.

---

## ✨ Features (MVP Complete)

- ✅ JWT-based authentication with Devise + Google OAuth
- ✅ Mentor application flow + admin approval
- ✅ Mentorship request system (one-time & ongoing)
- ✅ Startup + Mentor dashboards
- ✅ Blog posts, guides, opportunities, events (Resource Hub)
- ✅ Public searchable startup directory
- ✅ Admin dashboard powered by [Avo](https://avohq.io)
- ✅ Homepage builder (dynamic CMS-style section management)
- ✅ Full seed data & Docker setup for fast local dev

---

## 🔧 Tech Stack

| Layer              | Tech Used                          |
|-------------------|------------------------------------|
| Backend API       | Ruby on Rails 8 (API-first)        |
| Auth              | Devise, Devise-JWT, OmniAuth       |
| Admin CMS         | Avo (modern Rails admin)           |
| Styling           | Tailwind CSS + Gotham              |
| Forms             | Turbo + Hotwire + Rails UJS        |
| DB                | PostgreSQL                         |
| Background Jobs   | Sidekiq + Redis                    |
| File Storage      | ActiveStorage (Render Disk / S3)   |
| Email             | SendGrid (free tier)               |
| Deployment        | Render                             |

---

## 📁 Project Structure

- `app/models/` — core models: User, Mentor, Startup, etc.
- `app/views/` — API-driven + minimal server-rendered views
- `app/avo/` — admin config for all models and UI
- `app/controllers/` — standard Rails REST API
- `db/seeds.rb` — realistic sample data for all models
- `config/routes.rb` — clean RESTful structure + SPA fallback

---

## 🚀 Getting Started (Local Dev)

```bash
git clone https://github.com/nailab/platform.git
cd platform

# Setup environment
bundle install
yarn install

# Setup DB
rails db:create db:migrate db:seed

# Start server
bin/dev

Visit:

Frontend: http://localhost:3000

Admin Panel: http://localhost:3000/avo

🔐 Admin Access

Use seeded admin login (see db/seeds.rb):

Email: admin@nailab.org

Password: securepassword

📚 Resources

Figma Design System (Internal)

Marketing Content (PDF)

Mentor Onboarding Form (PDF)

🛣️ Roadmap

 MVP Complete ✅

 Mentor availability & session scheduling

 Stripe/M-Pesa tiered subscriptions

 In-platform messaging + real-time notifications

 Program pages with filtering and CTAs

 Full analytics + engagement charts

📄 License

MIT — Copyright © Nailab

🤝 Contributing

Fork this repo

Create your feature branch (git checkout -b feature/my-feature)

Commit your changes

Push to the branch

Open a Pull Request

Made with ❤️ in Africa 🇰🇪
