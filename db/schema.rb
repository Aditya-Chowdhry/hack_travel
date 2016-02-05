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

ActiveRecord::Schema.define(version: 20160204174310) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.text     "reviews"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "concepts", force: :cascade do |t|
    t.string   "name"
    t.string   "relevance"
    t.string   "typeHierarchy"
    t.string   "geo"
    t.string   "website"
    t.integer  "place_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "concepts", ["place_id"], name: "index_concepts_on_place_id", using: :btree

  create_table "entities", force: :cascade do |t|
    t.integer  "place_id"
    t.string   "name"
    t.string   "sentiment"
    t.string   "count"
    t.string   "relevance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "type_t"
  end

  add_index "entities", ["place_id"], name: "index_entities_on_place_id", using: :btree

  create_table "get_places", force: :cascade do |t|
    t.integer  "place_id"
    t.string   "image_url"
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "summary"
  end

  add_index "get_places", ["place_id"], name: "index_get_places_on_place_id", using: :btree

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

  add_foreign_key "concepts", "places"
  add_foreign_key "entities", "places"
  add_foreign_key "get_places", "places"
  add_foreign_key "places", "states"
end
