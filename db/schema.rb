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

ActiveRecord::Schema.define(version: 20160202101607) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.text     "reviews"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "places", force: :cascade do |t|
    t.string   "name"
    t.string   "link"
    t.integer  "state_id"
    t.text     "reviews"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "places", ["state_id"], name: "index_places_on_state_id", using: :btree

  create_table "states", force: :cascade do |t|
    t.string   "name"
    t.string   "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "places", "states"
end
