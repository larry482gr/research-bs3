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

ActiveRecord::Schema.define(version: 20150804132907) do

  create_table "citations", primary_key: "citation_id", force: :cascade do |t|
    t.text "citation_mla",     limit: 65535
    t.text "citation_apa",     limit: 65535
    t.text "citation_chicago", limit: 65535
  end

  create_table "citations_projects", id: false, force: :cascade do |t|
    t.integer "project_id",    limit: 4,               null: false
    t.string  "citation_id",   limit: 30, default: "", null: false
    t.string  "citation_type", limit: 30
  end

  add_index "citations_projects", ["citation_id", "project_id"], name: "index_citations_projects_on_citation_id_and_project_id", using: :btree
  add_index "citations_projects", ["project_id", "citation_id"], name: "index_citations_projects_on_project_id_and_citation_id", using: :btree

  create_table "history_projects", id: false, force: :cascade do |t|
    t.integer  "user_id",     limit: 4,  default: 0, null: false
    t.integer  "project_id",  limit: 4,  default: 0, null: false
    t.string   "from_value",  limit: 20,             null: false
    t.string   "to_value",    limit: 20,             null: false
    t.string   "change_type", limit: 20,             null: false
    t.datetime "created_at",                         null: false
  end

  create_table "history_user_infos", id: false, force: :cascade do |t|
    t.integer  "user_id",     limit: 4,   default: 0,  null: false
    t.string   "user_email",  limit: 50,               null: false
    t.string   "admin",       limit: 20,               null: false
    t.string   "from_value",  limit: 20,               null: false
    t.string   "to_value",    limit: 20,               null: false
    t.string   "change_type", limit: 50,  default: "", null: false
    t.string   "comment",     limit: 255
    t.datetime "created_at",                           null: false
  end

  create_table "invitations", force: :cascade do |t|
    t.integer  "from_user",          limit: 4,                       null: false
    t.integer  "project_id",         limit: 4,                       null: false
    t.integer  "project_profile_id", limit: 4,   default: 2,         null: false
    t.string   "status",             limit: 10,  default: "pending", null: false
    t.string   "reason",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",              limit: 50,                      null: false
  end

  add_index "invitations", ["project_id"], name: "index_invitations_on_project_id", using: :btree
  add_index "invitations", ["project_profile_id"], name: "index_invitations_on_project_profile_id", using: :btree

  create_table "languages", force: :cascade do |t|
    t.string "locale",   limit: 5,  null: false
    t.string "language", limit: 20, null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.string "label",       limit: 20, null: false
    t.string "description", limit: 30, null: false
  end

  create_table "profiles_rights", id: false, force: :cascade do |t|
    t.integer "profile_id", limit: 4, null: false
    t.integer "right_id",   limit: 4, null: false
  end

  add_index "profiles_rights", ["profile_id", "right_id"], name: "index_profiles_rights_on_profile_id_and_right_id", using: :btree
  add_index "profiles_rights", ["right_id", "profile_id"], name: "index_profiles_rights_on_right_id_and_profile_id", using: :btree

  create_table "project_files", force: :cascade do |t|
    t.integer  "project_id", limit: 4
    t.integer  "user_id",    limit: 4
    t.string   "filename",   limit: 255,             null: false
    t.string   "extension",  limit: 10
    t.string   "filepath",   limit: 255,             null: false
    t.boolean  "is_basic",   limit: 1
    t.integer  "reference",  limit: 4,   default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_files", ["project_id"], name: "index_project_files_on_project_id", using: :btree
  add_index "project_files", ["user_id"], name: "index_project_files_on_user_id", using: :btree

  create_table "project_profiles", force: :cascade do |t|
    t.string "label",       limit: 20, null: false
    t.string "description", limit: 30, null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "title",       limit: 100,   null: false
    t.text     "description", limit: 65535
    t.boolean  "is_private",  limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects_users", id: false, force: :cascade do |t|
    t.integer "user_id",            limit: 4, null: false
    t.integer "project_id",         limit: 4, null: false
    t.integer "project_profile_id", limit: 4
  end

  add_index "projects_users", ["project_id", "user_id"], name: "index_projects_users_on_project_id_and_user_id", using: :btree
  add_index "projects_users", ["user_id", "project_id"], name: "index_projects_users_on_user_id_and_project_id", using: :btree

  create_table "rights", force: :cascade do |t|
    t.string "label",       limit: 20, null: false
    t.string "description", limit: 50, null: false
  end

  create_table "user_infos", force: :cascade do |t|
    t.integer "user_id",     limit: 4,                   null: false
    t.string  "first_name",  limit: 20
    t.string  "last_name",   limit: 30
    t.integer "language_id", limit: 4,   default: 1,     null: false
    t.boolean "activated",   limit: 1,   default: false, null: false
    t.boolean "blacklisted", limit: 1,   default: false, null: false
    t.boolean "deleted",     limit: 1,   default: false, null: false
    t.integer "reports",     limit: 1,   default: 0,     null: false
    t.string  "token",       limit: 255
  end

  add_index "user_infos", ["language_id"], name: "index_user_infos_on_language_id", using: :btree
  add_index "user_infos", ["user_id"], name: "index_user_infos_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",   limit: 20, null: false
    t.string   "password",   limit: 50, null: false
    t.string   "email",      limit: 50, null: false
    t.integer  "profile_id", limit: 4,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["profile_id"], name: "index_users_on_profile_id", using: :btree

end
