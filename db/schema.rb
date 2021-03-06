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

ActiveRecord::Schema.define(version: 20140130155946) do

  create_table "agents", force: true do |t|
    t.string   "name"
    t.text     "comment",         limit: 500
    t.integer  "branch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "estate_agent_id"
  end

  add_index "agents", ["branch_id", "created_at"], name: "index_agents_on_branch_id_and_created_at"
  add_index "agents", ["estate_agent_id", "created_at"], name: "index_agents_on_estate_agent_id_and_created_at"

  create_table "agents_properties", id: false, force: true do |t|
    t.integer "agent_id"
    t.integer "property_id"
  end

  create_table "alerts", force: true do |t|
    t.integer  "user_id"
    t.string   "msg"
    t.integer  "property_id"
    t.string   "alert_type"
    t.boolean  "read",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "area_codes", force: true do |t|
    t.integer  "user_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "area_codes", ["user_id", "created_at"], name: "index_area_codes_on_user_id_and_created_at"

  create_table "branches", force: true do |t|
    t.string   "name"
    t.text     "comment",         limit: 500
    t.integer  "estate_agent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "external_ref"
  end

  add_index "branches", ["estate_agent_id", "created_at"], name: "index_branches_on_estate_agent_id_and_created_at"

  create_table "estate_agents", force: true do |t|
    t.string   "name"
    t.text     "comment",      limit: 500
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "external_ref"
  end

  add_index "estate_agents", ["user_id", "created_at"], name: "index_estate_agents_on_user_id_and_created_at"

  create_table "notes", force: true do |t|
    t.integer  "property_id"
    t.integer  "agent_id"
    t.integer  "branch_id"
    t.integer  "estate_agent_id"
    t.string   "content"
    t.string   "note_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "properties", force: true do |t|
    t.string   "address"
    t.string   "url",                     limit: 1000
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "post_code"
    t.string   "asking_price"
    t.string   "external_ref_deprecated"
    t.integer  "status_id"
    t.integer  "estate_agent_id"
    t.integer  "branch_id"
    t.integer  "agent_id"
    t.integer  "area_code_id"
    t.datetime "call_date"
    t.boolean  "sstc"
    t.boolean  "closed"
    t.datetime "view_date"
    t.string   "image_url"
    t.integer  "user_id"
    t.string   "price_qualifier"
    t.integer  "sstc_count"
    t.boolean  "listed",                               default: true
    t.boolean  "temp",                                 default: false
  end

  add_index "properties", ["created_at"], name: "index_properties_on_agent_id_and_created_at"
  add_index "properties", ["created_at"], name: "index_properties_on_branch_id_and_created_at"
  add_index "properties", ["created_at"], name: "index_properties_on_estate_agent_id_and_created_at"
  add_index "properties", ["user_id", "created_at"], name: "index_properties_on_user_id_and_created_at"

  create_table "statuses", force: true do |t|
    t.string   "description"
    t.string   "colour"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "statuses", ["user_id", "description"], name: "index_statuses_on_user_id_and_description", unique: true

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "expand_notes"
    t.boolean  "show_left_nav"
    t.boolean  "show_future"
    t.boolean  "show_overview"
    t.integer  "overview_weeks"
    t.integer  "properties_per_page"
    t.integer  "images"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
