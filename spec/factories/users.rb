# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    transient { role { :founder } }

    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:full_name) { |n| "User #{n}" }

    password { "SecurePassword123!" }
    confirmed_at { Time.current }

    trait :founder do
      role { 0 }
      association :user_profile, factory: :founder_profile
    end

    trait :mentor do
      role { 1 }
      association :user_profile, factory: :mentor_profile
    end

    trait :partner do
      role { 2 }
      association :user_profile, factory: :partner_profile
    end

    trait :admin do
      role { 3 }
      admin { true }
      association :user_profile, factory: :admin_profile
    end
  end

  factory :user_profile do
    full_name { "John Doe" }
    bio { "User bio" }
    onboarding_completed { true }
    profile_approval_status { "approved" }

    trait :founder_profile do
      role { "founder" }
      organization { "Startup Inc" }
      title { "CEO & Founder" }
    end

    trait :mentor_profile do
      role { "mentor" }
      organization { "Tech Corp" }
      title { "Senior Advisor" }
      years_experience { 10 }
      linkedin_url { "https://linkedin.com/in/mentor" }
      bio { "Experienced mentor with 10+ years in technology." }
      expertise { [ "Rails", "JavaScript", "Mentoring" ] }
      sectors { [ "Technology", "Startups" ] }
    end

    trait :partner_profile do
      role { "partner" }
      organization { "Partner Organization" }
      title { "Partner Manager" }
    end

    trait :admin_profile do
      role { "admin" }
      organization { "Nailab" }
      title { "System Administrator" }
    end

    trait :pending_approval do
      profile_approval_status { "pending" }
    end

    trait :rejected do
      profile_approval_status { "rejected" }
      profile_rejection_reason { "Rejected for testing" }
    end
  end
end
