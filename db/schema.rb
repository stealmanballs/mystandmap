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

ActiveRecord::Schema[7.2].define(version: 2026_03_12_144404) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "claims", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "stand_id", null: false
    t.string "status", default: "pending"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stand_id"], name: "index_claims_on_stand_id"
    t.index ["status"], name: "index_claims_on_status"
    t.index ["user_id", "stand_id"], name: "index_claims_on_user_id_and_stand_id", unique: true
    t.index ["user_id"], name: "index_claims_on_user_id"
  end

  create_table "stands", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.text "description"
    t.string "stand_type"
    t.string "address_1"
    t.string "address_2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.float "latitude"
    t.float "longitude"
    t.string "phone"
    t.string "email"
    t.string "website_url"
    t.string "facebook_url"
    t.string "google_maps_url"
    t.text "hours_text"
    t.text "products_text"
    t.boolean "open_now_override"
    t.boolean "verified"
    t.boolean "claimed"
    t.datetime "last_verified_at"
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city"], name: "index_stands_on_city"
    t.index ["claimed"], name: "index_stands_on_claimed"
    t.index ["slug"], name: "index_stands_on_slug", unique: true
    t.index ["stand_type"], name: "index_stands_on_stand_type"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "claims", "stands"
  add_foreign_key "claims", "users"
end
