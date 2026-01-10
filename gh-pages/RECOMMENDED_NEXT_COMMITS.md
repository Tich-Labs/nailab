# Recommended Next Commits
1. **Add LinkedIn OmniAuth sign-in and profile seeding**
   - **What to change**: Introduce `omniauth-linkedin` support, add a `LinkedinCredential` (or `Identity`) model/migration, update `User`/`RegistrationsController` to handle the callback, add a LinkedIn login button to the public auth pages, and store freshness data for auto-filling mentor profiles.
   - **Files to touch**: `Gemfile`, `config/initializers/devise.rb`, `config/routes.rb`, new `app/models/linkedin_credential.rb`, migration under `db/migrate/`, `app/controllers/users/omniauth_callbacks_controller.rb` (or equivalent), `app/views/pages/login.html.erb`, `app/views/pages/signup.html.erb`, and `app/models/user.rb`.
   - **Acceptance check**: Visiting `/users/auth/linkedin` returns LinkedIn login, callback creates/updates a user with profile fields populated, and the login button appears on the login/signup pages.

2. **Complete mentor request response UI (accept/decline/reschedule)**
   - **What to change**: Build a `MentorPortal::MentorshipRequestsController` with index/show, add `accept`, `decline`, and `reschedule` actions that call `Api::V1::MentorshipRequestsController#respond`, store `decline_reason`/`reschedule_time` in `MentorshipRequest`, and render cards in a new `mentor/mentorship_requests` view. Show notifications when a request status changes.
   - **Files to touch**: New controller under `app/controllers/mentor_portal/`, `app/views/mentor/mentorship_requests/*.html.erb`, updates to `config/routes.rb`, `app/models/mentorship_request.rb` (new fields/validations), `db/migrate/`, and `app/views/shared/_mentor_sidebar.html.erb` (add link if necessary).
   - **Acceptance check**: A mentor can visit the new `/mentor/mentorship_requests` page, see pending requests, and accept/decline/reschedule with reason/time; founders receive notifications when the status changes.

3. **Align founder monthly metrics/progress screens with schema**
   - **What to change**: Update the `monthly_metrics` migration to include `growth_rate`, `churn_rate`, `users`, `notes`, or map the existing `customers` field to the UI, then adjust the controller strong params plus the new/edit views and founder progress partials (remove references to nonexistent columns). Add `milestone.category` column if needed or simplify the display.
   - **Files to touch**: `db/migrate/*monthly_metrics*.rb`, `app/controllers/founder/monthly_metrics_controller.rb`, `app/views/founder/monthly_metrics/*`, `app/views/founder/progresses/show.html.erb`, `app/views/founder/dashboard/_progress_charts.html.erb`, and corresponding model/tests.
   - **Acceptance check**: Monthly metric entries save without `ActiveModel::MissingAttributeError`, the progress view renders actual `customers`/`burn_rate` values, and there are no missing-column errors for milestones.

4. **Normalize subscription model/view and stub payment flow**
   - **What to change**: Extend `subscriptions` table with columns such as `plan_name`, `price_cents`, `billing_cycle`, `next_billing_date`, `features` (text), `active` (boolean), and `receipt_url`. Update `Subscription` model/`Founder::SubscriptionsController` to manage these fields, simplify the `show`/`new` views accordingly, and add a placeholder `SubscriptionPaymentsController` that can create charges via a fake gateway (or wrap Stripe once chosen).
   - **Files to touch**: `db/migrate/*create_subscriptions.rb` (or new migration), `app/models/subscription.rb`, `app/controllers/founder/subscriptions_controller.rb`, views under `app/views/founder/subscriptions/*`, and optionally `app/services/subscription_payment_service.rb` and `config/routes.rb` for payment hooks.
   - **Acceptance check**: Founders can create/update subscriptions, the show page renders plan/price data without calling missing attributes, and a stub payment request/log is generated for each creation.

5. **Expose matching results to founders and fix API signature**
   - **What to change**: Correct `Api::V1::MatchesController#index` to call `MatchingService.new(params[:founder_id])` (optionally pass parsed preferences), add serialization for the `match[:score]`+reasons, and create a founder-facing controller/view (e.g., `Founder::MatchesController`) that consumes the API to display ranked matches. Ensure the UI links to each mentor profile/request flow.
   - **Files to touch**: `app/controllers/api/v1/matches_controller.rb`, `app/services/matching_service.rb` (if preferences needed), new `app/controllers/founder/matches_controller.rb`, view templates (`app/views/founder/matches/index.html.erb`), and `config/routes.rb` (route for `/founder/matches`).
   - **Acceptance check**: Visiting `/founder/matches` shows ranked mentors with scores/reasons, the API responds without raising `ArgumentError`, and clicking a mentor leads to the existing profile/request flow.

Additional commits (post MVP) could tackle notifications, mentor/starter sessions data, and support page content once these high-impact gaps are addressed.