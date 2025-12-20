# Missing / Incomplete Components

## Models

- **OmniAuthCredential (or equivalent)** – needed for LinkedIn social sign-in so that mentors can persist `provider`, `uid`, and profile data. Attributes: `user_id`, `provider`, `uid`, `access_token`, `data` (jsonb).
- **Mentor (schema gaps)** – views assume `specialties`, `industries`, `availability`, `company`, `years_experience`, `name`, `bio`, `expertise`, but the table only has `name`, `title`, `photo`, `expertise`, `bio`, and `user_id`. Add the missing columns (and/or delegate to `UserProfile`).
- **MonthlyMetric** – views reference `users`, `growth_rate`, `churn_rate`, `notes`, but the schema stores `customers`, `runway`, `burn_rate`. Either rename views or add columns `users`, `growth_rate`, `churn_rate`, `notes` to the table.
- **Subscription** – controller/view expect `plan_name`, `price`, `billing_cycle`, `next_billing_date`, `features`, `active`, but the table only has `tier`, `payment_method`, `status`. Extend schema with these fields plus `expires_at`, `receipt_url` if needed for receipts.

## Controllers / Actions

- **Founder::MentorshipRequestsController#new** – route exists in views, but controller lacks `new` action and form view, so founders cannot create requests from the intended CTA.
- **Payment/SubscriptionsController** – need actions for updating/canceling subscriptions, triggering payment gateway hooks, sending confirmations, and generating receipts.
- **MatchesController (UI)** – `Api::V1::MatchesController#index` currently crashes because it passes extra args to `MatchingService`; the API also lacks a founder-facing UI or controller that surfaces matches and reasons.
- **MonthlyMetricsController** – new/edit forms reference fields that do not exist; action should be reviewed to align strong params with columns.

## Views / Partials

- `app/views/founder/mentorship_requests/new.html.erb` – absent; without it the "Request Session" link 404s.
- `mentor/startups/index.html.erb` & `mentor/startups/show.html.erb` – currently placeholders; they should render the `@startups` collection retrieved by the controller.
- `founder/dashboard/_recommended_mentors.html.erb` – references missing `mentor` attributes; either change views to use `mentor_profile` data or extend schema.
- `founder/progresses/show.html.erb` and `founder/monthly_metrics/*` – reference nonexistent columns (e.g., `milestone.category`, `metric.users`, `metric.growth_rate`); the views need to match schema or migrations must be updated.
- `founder/subscriptions/show.html.erb` & `.new.html.erb` – reference `plan_name`, `price`, etc.; views must align with `Subscription` model or schema.
- `pages/signup.html.erb` / `pages/login.html.erb` – add LinkedIn sign-in button and link to OmniAuth callback.
- `layouts/founder_dashboard.html.erb` – lacks the requested top navigation bar (avatar + bell); add a header partial with notification dropdown.

## Routes

- `get '/users/auth/linkedin/callback'` (and `get '/users/auth/linkedin'`) for OmniAuth.
- `new` route for `founder/mentorship_requests` so the CTA works.
- Payment webhook route (e.g., `/payments/webhook`) to consume gateway notifications.
- Match display route for founders (e.g., `get '/founder/matches'`).

## Background Jobs / Notifications

- Subscription confirmation job – send email receipt + record `Notification` after `Subscription#create`.
- Matching alert job that notifies founders when new high-score mentors appear.

## Tests (needed)

- Feature specs for mentor onboarding and LinkedIn sign-in to guard the multi-step wizard.
- Integration test for `MatchingService` + match list rendering to ensure `match[:score]` and reasons survive changes.
- System test for subscription flow (new/create/cancel) once payment logic is in place.
- View/component tests for monthly metrics and progress charts to guard against schema drift.
