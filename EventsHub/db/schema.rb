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

ActiveRecord::Schema.define(version: 20151019205523) do

  create_table "administrators", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "Title",       limit: 255
    t.text     "Description", limit: 255
    t.decimal  "Latitude",                precision: 6
    t.decimal  "Longitude",               precision: 6
    t.string   "Category",    limit: 255
    t.integer  "StartDay"
    t.integer  "StartMonth"
    t.integer  "StartYear"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "Address",     limit: 255
    t.integer  "StartMinute"
    t.integer  "StartHour"
    t.integer  "EndMinute"
    t.integer  "EndHour"
    t.integer  "EndDay"
    t.integer  "EndMonth"
    t.integer  "EndYear"
    t.integer  "user_id"
  end

  add_index "events", ["user_id"], name: "index_events_on_user_id"

  create_table "promoters", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",        limit: 255
    t.string   "password_digest", limit: 255
    t.string   "email",           limit: 255
    t.string   "first_name",      limit: 255
    t.string   "last_name",       limit: 255
    t.date     "date_of_birth"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "session_token",   limit: 255
  end

end
