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

ActiveRecord::Schema.define(version: 20171112051441) do

  create_table "server_histories", force: :cascade do |t|
    t.integer  "server_id"
    t.string   "name"
    t.string   "hostname"
    t.integer  "port"
    t.bigint   "ram_capacity"
    t.bigint   "current_ram_usage"
    t.bigint   "free_ram"
    t.bigint   "cores_available"
    t.bigint   "current_core_usage"
    t.boolean  "active"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "usage_in_gb"
    t.integer  "usage_in_mb"
    t.integer  "usage_in_kb"
    t.index ["server_id"], name: "index_server_histories_on_server_id"
  end

  create_table "servers", force: :cascade do |t|
    t.string   "name"
    t.string   "hostname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "port"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
