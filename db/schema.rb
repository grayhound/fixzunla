# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150625192457) do

  create_table "shortened_url_browsers", force: :cascade do |t|
    t.integer  "shortened_url_id"
    t.string   "browser_name"
    t.integer  "count",            default: 0
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "shortened_url_browsers", ["browser_name"], name: "index_shortened_url_browsers_on_browser_name", using: :btree
  add_index "shortened_url_browsers", ["shortened_url_id"], name: "index_shortened_url_browsers_on_shortened_url_id", using: :btree

  create_table "shortened_url_countries", force: :cascade do |t|
    t.integer  "shortened_url_id"
    t.string   "country_code"
    t.integer  "count",            default: 0
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "shortened_url_countries", ["country_code"], name: "index_shortened_url_countries_on_country_code", using: :btree
  add_index "shortened_url_countries", ["shortened_url_id"], name: "index_shortened_url_countries_on_shortened_url_id", using: :btree

  create_table "shortened_url_platforms", force: :cascade do |t|
    t.integer  "shortened_url_id"
    t.string   "platform"
    t.integer  "count",            default: 0
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "shortened_url_platforms", ["platform"], name: "index_shortened_url_platforms_on_platform", using: :btree
  add_index "shortened_url_platforms", ["shortened_url_id"], name: "index_shortened_url_platforms_on_shortened_url_id", using: :btree

  create_table "shortened_urls", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "owner_type", limit: 20
    t.string   "url",                               null: false
    t.string   "unique_key", limit: 10,             null: false
    t.integer  "use_count",             default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shortened_urls", ["owner_id", "owner_type"], name: "index_shortened_urls_on_owner_id_and_owner_type", using: :btree
  add_index "shortened_urls", ["unique_key"], name: "index_shortened_urls_on_unique_key", unique: true, using: :btree
  add_index "shortened_urls", ["url"], name: "index_shortened_urls_on_url", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
