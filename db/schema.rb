# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_02_03_000002) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "about_pages", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "about_sections", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.string "section_type"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "blog_pages", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "bookmarks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "resource_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["resource_id"], name: "index_bookmarks_on_resource_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "categories_programs", id: false, force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "program_id", null: false
    t.index ["category_id", "program_id"], name: "index_categories_programs_on_category_id_and_program_id", unique: true
    t.index ["program_id"], name: "index_categories_programs_on_program_id"
  end

  create_table "connections", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "peer_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["peer_id"], name: "index_connections_on_peer_id"
    t.index ["user_id"], name: "index_connections_on_user_id"
  end

  create_table "contact_pages", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "contact_us", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.text "message"
    t.string "name"
    t.string "subject"
    t.datetime "updated_at", null: false
  end

  create_table "conversations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "mentor_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["mentor_id"], name: "index_conversations_on_mentor_id"
    t.index ["user_id"], name: "index_conversations_on_user_id"
  end

  create_table "deleted_accounts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_deleted_accounts_on_email", unique: true
  end

  create_table "events_webinars_pages", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "faqs", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.text "answer", null: false
    t.datetime "created_at", null: false
    t.integer "display_order", default: 1, null: false
    t.text "question", null: false
    t.datetime "updated_at", null: false
  end

  create_table "focus_areas", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "display_order", default: 1, null: false
    t.string "icon"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_focus_areas_on_active"
    t.index ["display_order"], name: "index_focus_areas_on_display_order"
  end

  create_table "hero_slides", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "cta_link"
    t.string "cta_text"
    t.integer "display_order", default: 1, null: false
    t.string "image_url"
    t.text "subtitle"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["display_order"], name: "index_hero_slides_on_display_order"
  end

  create_table "home_pages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "structured_content", default: {}, null: false
    t.datetime "updated_at", null: false
  end

  create_table "homepages", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "identities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "provider"
    t.string "uid"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.datetime "exp", null: false
    t.string "jti", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti"
  end

  create_table "knowledge_hub_pages", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "logos", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.integer "display_order", default: 0, null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "mentors", force: :cascade do |t|
    t.text "bio"
    t.datetime "created_at", null: false
    t.string "expertise"
    t.string "name"
    t.string "photo"
    t.string "slug"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["slug"], name: "index_mentors_on_slug", unique: true
    t.index ["user_id"], name: "index_mentors_on_user_id"
  end

  create_table "mentorship_connections", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "founder_id", null: false
    t.bigint "mentor_id", null: false
    t.bigint "mentorship_request_id", null: false
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.index ["founder_id"], name: "index_mentorship_connections_on_founder_id"
    t.index ["mentor_id"], name: "index_mentorship_connections_on_mentor_id"
    t.index ["mentorship_request_id"], name: "index_mentorship_connections_on_mentorship_request_id"
    t.index ["status"], name: "index_mentorship_connections_on_status"
  end

  create_table "mentorship_requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "decline_reason"
    t.text "feedback"
    t.bigint "founder_id", null: false
    t.bigint "mentor_id", null: false
    t.text "message"
    t.datetime "proposed_time"
    t.integer "rating"
    t.text "reschedule_reason"
    t.datetime "reschedule_requested_at"
    t.datetime "responded_at"
    t.string "status", default: "pending", null: false
    t.datetime "updated_at", null: false
    t.index ["founder_id"], name: "index_mentorship_requests_on_founder_id"
    t.index ["mentor_id"], name: "index_mentorship_requests_on_mentor_id"
    t.index ["proposed_time"], name: "index_mentorship_requests_on_proposed_time"
    t.index ["status"], name: "index_mentorship_requests_on_status"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.bigint "conversation_id", null: false
    t.datetime "created_at", null: false
    t.bigint "sender_id", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "milestones", force: :cascade do |t|
    t.boolean "completed"
    t.datetime "created_at", null: false
    t.text "description"
    t.date "due_date"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_milestones_on_user_id"
  end

  create_table "monthly_metrics", force: :cascade do |t|
    t.decimal "burn_rate"
    t.decimal "cash_at_hand", precision: 10, scale: 2
    t.integer "churned_customers"
    t.datetime "created_at", null: false
    t.integer "customers"
    t.string "funding_stage"
    t.decimal "funds_raised", precision: 10, scale: 2
    t.string "investors_engaged"
    t.boolean "is_projection", default: false, null: false
    t.decimal "mrr"
    t.integer "new_paying_customers"
    t.date "period"
    t.text "product_progress"
    t.integer "projection_index"
    t.integer "runway"
    t.bigint "startup_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["period"], name: "index_monthly_metrics_on_period"
    t.index ["startup_id", "is_projection", "projection_index"], name: "index_monthly_metrics_on_projection"
    t.index ["startup_id"], name: "index_monthly_metrics_on_startup_id"
    t.index ["user_id"], name: "index_monthly_metrics_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "link"
    t.text "message"
    t.jsonb "metadata"
    t.string "notif_type"
    t.boolean "read", default: false, null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["notif_type"], name: "index_notifications_on_notif_type"
    t.index ["user_id", "read"], name: "index_notifications_on_user_id_and_read"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "opportunities", force: :cascade do |t|
    t.string "application_url"
    t.string "category"
    t.datetime "created_at", null: false
    t.date "deadline"
    t.text "description"
    t.string "organizer"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "opportunities_pages", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "opportunity_submissions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "details"
    t.bigint "opportunity_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["opportunity_id"], name: "index_opportunity_submissions_on_opportunity_id"
    t.index ["user_id"], name: "index_opportunity_submissions_on_user_id"
  end

  create_table "partners", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.integer "display_order", default: 1, null: false
    t.string "logo_url"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.string "website_url"
    t.index ["active"], name: "index_partners_on_active"
    t.index ["display_order"], name: "index_partners_on_display_order"
  end

  create_table "peer_messages", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.bigint "recipient_id", null: false
    t.bigint "sender_id", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id"], name: "index_peer_messages_on_recipient_id"
    t.index ["sender_id"], name: "index_peer_messages_on_sender_id"
  end

  create_table "pricing_pages", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "profile_audits", force: :cascade do |t|
    t.string "action", null: false
    t.bigint "admin_id", null: false
    t.datetime "created_at", null: false
    t.text "reason"
    t.datetime "updated_at", null: false
    t.bigint "user_profile_id", null: false
    t.index ["admin_id"], name: "index_profile_audits_on_admin_id"
    t.index ["user_profile_id"], name: "index_profile_audits_on_user_profile_id"
  end

  create_table "programs", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.text "content"
    t.string "cover_image_url"
    t.datetime "created_at", null: false
    t.text "description"
    t.date "end_date"
    t.text "inline_image_urls", default: [], array: true
    t.string "program_type"
    t.text "short_summary"
    t.string "slug", null: false
    t.date "start_date"
    t.string "status", default: "completed"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "video_url"
    t.index ["active"], name: "index_programs_on_active"
    t.index ["slug"], name: "index_programs_on_slug", unique: true
  end

  create_table "programs_pages", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.string "intro_title"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "projection_audits", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "field"
    t.text "new_value"
    t.text "old_value"
    t.date "period"
    t.string "reason"
    t.bigint "startup_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["startup_id"], name: "index_projection_audits_on_startup_id"
    t.index ["user_id"], name: "index_projection_audits_on_user_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "rated_at", default: -> { "CURRENT_TIMESTAMP" }
    t.integer "rating_score"
    t.bigint "resource_id", null: false
    t.integer "score"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["resource_id"], name: "index_ratings_on_resource_id"
    t.index ["user_id", "resource_id"], name: "index_ratings_on_user_id_and_resource_id", unique: true
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "resources", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "hero_image_url"
    t.text "inline_image_urls", default: [], array: true
    t.datetime "published_at"
    t.boolean "requires_subscription", default: false
    t.string "resource_type"
    t.string "slug"
    t.integer "tier", default: 0
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["active"], name: "index_resources_on_active"
    t.index ["published_at"], name: "index_resources_on_published_at"
    t.index ["requires_subscription"], name: "index_resources_on_requires_subscription"
    t.index ["slug"], name: "index_resources_on_slug", unique: true
    t.index ["tier"], name: "index_resources_on_tier"
  end

  create_table "scenario_presets", force: :cascade do |t|
    t.decimal "burn_change_pct", precision: 5, scale: 2, default: "0.0"
    t.decimal "churn_pct", precision: 5, scale: 2, default: "2.0"
    t.datetime "created_at", null: false
    t.decimal "growth_pct", precision: 5, scale: 2, default: "8.0"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_scenario_presets_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date"
    t.bigint "mentor_id", null: false
    t.time "time"
    t.string "topic"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["mentor_id"], name: "index_sessions_on_mentor_id"
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "startup_invites", force: :cascade do |t|
    t.datetime "accepted_at"
    t.datetime "created_at", null: false
    t.string "invitee_email", null: false
    t.string "invitee_name"
    t.bigint "inviter_id", null: false
    t.string "role"
    t.datetime "sent_at"
    t.bigint "startup_id", null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.index ["invitee_email"], name: "index_startup_invites_on_invitee_email"
    t.index ["inviter_id"], name: "index_startup_invites_on_inviter_id"
    t.index ["startup_id"], name: "index_startup_invites_on_startup_id"
    t.index ["token"], name: "index_startup_invites_on_token", unique: true
  end

  create_table "startup_profiles", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.text "challenge_details"
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "founded_year"
    t.decimal "funding_raised", precision: 14, scale: 2
    t.string "funding_stage"
    t.string "location"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.string "logo_url"
    t.jsonb "mentorship_areas"
    t.string "phone_number"
    t.string "preferred_mentorship_mode"
    t.boolean "profile_visibility", default: false, null: false
    t.string "sector"
    t.string "slug"
    t.string "stage"
    t.string "startup_name", null: false
    t.text "target_market"
    t.integer "team_size", default: 0
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.text "value_proposition"
    t.string "website_url"
    t.index ["active"], name: "index_startup_profiles_on_active"
    t.index ["slug"], name: "index_startup_profiles_on_slug", unique: true
    t.index ["user_id"], name: "index_startup_profiles_on_user_id"
  end

  create_table "startup_updates", force: :cascade do |t|
    t.decimal "burn_rate", precision: 12, scale: 2, null: false
    t.decimal "cash_at_hand", precision: 15, scale: 2, null: false
    t.integer "churned_customers", null: false
    t.datetime "created_at", null: false
    t.string "funding_stage"
    t.decimal "funds_raised", precision: 15, scale: 2
    t.string "investors_engaged"
    t.decimal "mrr", precision: 12, scale: 2, null: false
    t.integer "new_paying_customers", null: false
    t.text "product_progress"
    t.integer "report_month", null: false
    t.integer "report_year", null: false
    t.bigint "startup_id", null: false
    t.datetime "updated_at", null: false
    t.index ["startup_id", "report_month", "report_year"], name: "index_startup_updates_on_startup_and_month_year", unique: true
    t.index ["startup_id"], name: "index_startup_updates_on_startup_id"
  end

  create_table "startups", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "location"
    t.text "mentor_focus"
    t.string "name", null: false
    t.string "sector"
    t.string "stage"
    t.string "status"
    t.boolean "team_initialized", default: false
    t.integer "team_size", default: 1
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "website_url"
    t.index ["active"], name: "index_startups_on_active"
    t.index ["sector"], name: "index_startups_on_sector"
    t.index ["team_initialized"], name: "index_startups_on_team_initialized"
    t.index ["team_size"], name: "index_startups_on_team_size"
    t.index ["user_id"], name: "index_startups_on_user_id"
  end

  create_table "static_pages", force: :cascade do |t|
    t.string "contact_address"
    t.string "contact_email"
    t.string "contact_phone"
    t.text "content"
    t.datetime "created_at", null: false
    t.string "slug", null: false
    t.jsonb "structured_content", default: {}, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_static_pages_on_slug", unique: true
  end

  create_table "subscriptions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "payment_method"
    t.string "status"
    t.string "tier"
    t.integer "trial_days", default: 5
    t.datetime "trial_started_at"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["trial_started_at"], name: "index_subscriptions_on_trial_started_at"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "support_messages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "message", null: false
    t.string "sender_type", default: "user", null: false
    t.bigint "support_ticket_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["sender_type"], name: "index_support_messages_on_sender_type"
    t.index ["support_ticket_id"], name: "index_support_messages_on_support_ticket_id"
    t.index ["user_id"], name: "index_support_messages_on_user_id"
  end

  create_table "support_ticket_replies", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.bigint "support_ticket_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "user_type"
    t.index ["support_ticket_id"], name: "index_support_ticket_replies_on_support_ticket_id"
    t.index ["user_id"], name: "index_support_ticket_replies_on_user_id"
    t.index ["user_type", "user_id"], name: "index_support_ticket_replies_on_user"
    t.index ["user_type"], name: "index_support_ticket_replies_on_user_type"
  end

  create_table "support_tickets", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.string "portal"
    t.string "status", default: "open", null: false
    t.string "subject", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["portal"], name: "index_support_tickets_on_portal"
    t.index ["status"], name: "index_support_tickets_on_status"
    t.index ["user_id"], name: "index_support_tickets_on_user_id"
  end

  create_table "team_members", force: :cascade do |t|
    t.text "bio"
    t.datetime "created_at", null: false
    t.boolean "is_founder", default: false
    t.datetime "joined_at", default: -> { "CURRENT_TIMESTAMP" }
    t.integer "role", default: 2, null: false
    t.bigint "startup_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["is_founder"], name: "index_team_members_on_is_founder"
    t.index ["role"], name: "index_team_members_on_role"
    t.index ["startup_id", "user_id"], name: "index_team_members_on_startup_id_and_user_id", unique: true
    t.index ["startup_id"], name: "index_team_members_on_startup_id"
    t.index ["user_id"], name: "index_team_members_on_user_id"
  end

  create_table "testimonials", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "author_name", null: false
    t.string "author_role"
    t.datetime "created_at", null: false
    t.integer "display_order", default: 1, null: false
    t.string "organization"
    t.string "photo_url"
    t.text "quote"
    t.integer "rating", default: 5, null: false
    t.datetime "updated_at", null: false
    t.string "website_url"
    t.index ["active"], name: "index_testimonials_on_active"
    t.index ["display_order"], name: "index_testimonials_on_display_order"
  end

  create_table "user_profiles", force: :cascade do |t|
    t.text "advisory_description"
    t.boolean "advisory_experience", default: false, null: false
    t.integer "availability_hours_month", default: 0, null: false
    t.jsonb "availability_windows", default: [], null: false
    t.text "bio"
    t.jsonb "cadence_preferences", default: [], null: false
    t.string "city"
    t.jsonb "conflict_of_interest", default: [], null: false
    t.string "country"
    t.datetime "created_at", null: false
    t.string "currency"
    t.jsonb "expertise"
    t.string "full_name"
    t.jsonb "languages", default: [], null: false
    t.string "linkedin_url"
    t.string "location"
    t.text "mentorship_approach"
    t.text "motivation"
    t.boolean "onboarding_completed", default: false, null: false
    t.string "onboarding_step"
    t.string "organization"
    t.string "other_social_platform"
    t.string "other_social_url"
    t.string "phone"
    t.string "photo"
    t.string "photo_url"
    t.boolean "photo_visibility", default: true, null: false
    t.string "preferred_mentorship_mode"
    t.boolean "pro_bono", default: false, null: false
    t.string "professional_website"
    t.string "profile_approval_status", default: "pending", null: false
    t.text "profile_rejection_reason"
    t.boolean "profile_visibility", default: true, null: false
    t.jsonb "program_tiers", default: [], null: false
    t.decimal "rate_per_hour", precision: 10, scale: 2
    t.string "role"
    t.jsonb "sectors"
    t.string "slug"
    t.jsonb "stage_preference"
    t.string "time_zone"
    t.string "title"
    t.string "twitter_url"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "years_experience"
    t.index ["photo_visibility"], name: "index_user_profiles_on_photo_visibility"
    t.index ["profile_approval_status"], name: "index_user_profiles_on_profile_approval_status"
    t.index ["slug"], name: "index_user_profiles_on_slug", unique: true
    t.index ["user_id"], name: "index_user_profiles_on_user_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false, null: false
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "provider"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 0, null: false
    t.string "slug"
    t.string "uid"
    t.string "unconfirmed_email"
    t.datetime "updated_at", null: false
    t.index ["admin"], name: "index_users_on_admin"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookmarks", "resources"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "connections", "users"
  add_foreign_key "connections", "users", column: "peer_id"
  add_foreign_key "conversations", "mentors"
  add_foreign_key "conversations", "users"
  add_foreign_key "identities", "users"
  add_foreign_key "mentors", "users"
  add_foreign_key "mentorship_connections", "mentorship_requests"
  add_foreign_key "mentorship_connections", "users", column: "founder_id"
  add_foreign_key "mentorship_connections", "users", column: "mentor_id"
  add_foreign_key "mentorship_requests", "users", column: "founder_id"
  add_foreign_key "mentorship_requests", "users", column: "mentor_id"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "milestones", "users"
  add_foreign_key "monthly_metrics", "startups"
  add_foreign_key "notifications", "users"
  add_foreign_key "opportunity_submissions", "opportunities"
  add_foreign_key "opportunity_submissions", "users"
  add_foreign_key "peer_messages", "users", column: "recipient_id"
  add_foreign_key "peer_messages", "users", column: "sender_id"
  add_foreign_key "ratings", "resources"
  add_foreign_key "ratings", "users"
  add_foreign_key "sessions", "mentors"
  add_foreign_key "sessions", "users"
  add_foreign_key "startup_invites", "startups"
  add_foreign_key "startup_invites", "users", column: "inviter_id"
  add_foreign_key "startup_profiles", "users"
  add_foreign_key "startup_updates", "startups"
  add_foreign_key "startups", "users"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "support_messages", "support_tickets"
  add_foreign_key "support_messages", "users"
  add_foreign_key "support_ticket_replies", "support_tickets"
  add_foreign_key "support_tickets", "users"
  add_foreign_key "team_members", "startups"
  add_foreign_key "team_members", "users"
  add_foreign_key "user_profiles", "users"
end
