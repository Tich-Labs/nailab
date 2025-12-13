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

ActiveRecord::Schema[8.1].define(version: 2025_12_13_020842) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.bigint "author_id"
    t.string "author_type"
    t.text "body"
    t.datetime "created_at", null: false
    t.string "namespace"
    t.bigint "resource_id"
    t.string "resource_type"
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
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

  create_table "admin_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "blog_posts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "published_on"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date"
    t.text "description"
    t.string "location"
    t.string "registration_url"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "homepage_sections", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.string "cta_text"
    t.string "cta_url"
    t.integer "position"
    t.integer "section_type"
    t.string "subtitle"
    t.string "title"
    t.datetime "updated_at", null: false
    t.boolean "visible"
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "jti"
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti"
  end

  create_table "mentor_applications", force: :cascade do |t|
    t.text "approach"
    t.integer "availability_hours"
    t.datetime "created_at", null: false
    t.string "current_role"
    t.string "email"
    t.integer "experience_years"
    t.string "full_name"
    t.boolean "has_advisory_experience"
    t.string "industries"
    t.string "linkedin_url"
    t.string "mentorship_topics"
    t.integer "mode"
    t.text "motivation"
    t.string "organization"
    t.integer "preferred_stages"
    t.decimal "rate"
    t.text "short_bio"
    t.integer "status"
    t.datetime "updated_at", null: false
  end

  create_table "mentors", force: :cascade do |t|
    t.boolean "advisor_or_investor"
    t.boolean "approved"
    t.integer "availability_hours_per_month"
    t.boolean "available"
    t.text "bio"
    t.datetime "created_at", null: false
    t.string "current_affiliation"
    t.string "email"
    t.string "expertise"
    t.decimal "hourly_rate"
    t.string "linkedin_url"
    t.text "mentorship_approach"
    t.string "mentorship_areas"
    t.string "mentorship_industries"
    t.string "mentorship_mode"
    t.text "motivation"
    t.string "name"
    t.string "preferred_stage"
    t.datetime "updated_at", null: false
    t.string "website_url"
    t.integer "years_experience"
  end

  create_table "mentorship_requests", force: :cascade do |t|
    t.string "commitment_length"
    t.datetime "created_at", null: false
    t.date "date"
    t.string "full_name"
    t.string "funding_structure"
    t.text "goal"
    t.bigint "mentor_id"
    t.text "mentorship_needs"
    t.string "phone_number"
    t.string "preferred_mentorship_mode"
    t.string "request_type", null: false
    t.text "startup_bio"
    t.string "startup_funding"
    t.string "startup_industry"
    t.string "startup_name"
    t.string "startup_stage"
    t.string "status", default: "pending", null: false
    t.text "target_market"
    t.string "top_mentorship_areas"
    t.string "topic"
    t.string "total_funding"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["mentor_id"], name: "index_mentorship_requests_on_mentor_id"
    t.index ["user_id"], name: "index_mentorship_requests_on_user_id"
  end

  create_table "mentorship_sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "date"
    t.integer "duration"
    t.text "feedback"
    t.bigint "mentorship_request_id", null: false
    t.text "notes"
    t.integer "rating"
    t.datetime "updated_at", null: false
    t.index ["mentorship_request_id"], name: "index_mentorship_sessions_on_mentorship_request_id"
  end

  create_table "navigation_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "location"
    t.string "path"
    t.integer "position"
    t.string "title"
    t.datetime "updated_at", null: false
    t.boolean "visible"
  end

  create_table "opportunities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "deadline"
    t.text "description"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "url"
  end

  create_table "programs", force: :cascade do |t|
    t.string "apply_link"
    t.text "body"
    t.integer "category"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.integer "position"
    t.text "summary"
    t.string "title"
    t.datetime "updated_at", null: false
    t.boolean "visible"
  end

  create_table "site_menu_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "location"
    t.string "path"
    t.integer "position"
    t.string "title"
    t.datetime "updated_at", null: false
    t.boolean "visible"
  end

  create_table "startups", force: :cascade do |t|
    t.boolean "approved"
    t.datetime "created_at", null: false
    t.text "description"
    t.date "founded_on"
    t.string "industry"
    t.string "name"
    t.datetime "updated_at", null: false
    t.string "website"
  end

  create_table "template_guides", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "testimonials", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "position"
    t.text "quote"
    t.datetime "updated_at", null: false
    t.boolean "visible"
  end

  create_table "users", force: :cascade do |t|
    t.string "avatar"
    t.text "bio"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "expertise"
    t.string "location"
    t.string "name"
    t.string "provider"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role"
    t.string "sector"
    t.string "uid"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "mentorship_requests", "mentors"
  add_foreign_key "mentorship_requests", "users"
  add_foreign_key "mentorship_sessions", "mentorship_requests"
end
