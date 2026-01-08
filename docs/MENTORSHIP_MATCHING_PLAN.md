
# Mentorship Matching Roadmap

**Note:** As features are implemented, update their status here and in [FEATURE_IMPLEMENTATION_AUDIT.md](FEATURE_IMPLEMENTATION_AUDIT.md).

## MVP
- **Hard filters**: match mentors to founders by focus area overlap, industry, availability. Exclude mentors without confirmed availability or conflicting locations/time zones.
- **Scoring layers**: calculate compatibility score using shared interests, experience level (years), and language/region preferences.
- **Data surfaces**: expose mentor profiles (bio, expertise, testimonials) plus request summary (goal, stage, desired cadence) for quick review.
- **Founder flow**: add mentor discovery view (search + filters) and `Request Mentor` action that creates `MentorshipRequest` linked to `StartupProfile`.
- **Admin oversight**: log matches and expose auto-suggestions for admin review before requests are sent to mentors.

## Alpha
- **Weighted scoring**: refine match weights (focus area 3x, availability 2x, testimonials 1x) with config flags; log scores for ranking adjustments.
- **Mentor responses**: add status tracking (pending, accepted, declined) on `MentorshipRequest` and simple notification via email or onboarding slack.
- **Feedback loop**: capture mentor feedback on a request (fit, interest) to re-train weights and surface in dashboards.
- **Founder dashboard**: show active mentor matches, their status, and next recommended mentors based on recent requests.
- **RailsAdmin tooling**: add admin UI for flagging mentors as unavailable, editing availability slots, and measuring founder satisfaction.

## Beta
- **Learning layer**: introduce ML/heuristic-assisted matching that ingests historical success signals (sessions, satisfaction) to surface best-fit mentors.
- **Mentor mentoring**: allow mentors to self-apply for requests, and support multi-mentor cohorts if founders need broader coverage.
- **Proactive nudges**: build automated reminders for mentors/ founders when a match is pending or needing follow-up; include in-app notifications.
- **Analytics & reporting**: add dashboards that show time-to-match, match quality, and coverage gaps (e.g., underserved focus areas).
- **Scale ops**: expand to support geographic cohorts, regional mentor pools, and manage mentor rotation with workload balancing hints.
