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

ActiveRecord::Schema.define(version: 2024_07_23_041004) do

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.string "affiliation"
    t.string "openalex_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "publications_count"
  end

  create_table "person_publications", force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "publication_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["person_id"], name: "index_person_publications_on_person_id"
    t.index ["publication_id"], name: "index_person_publications_on_publication_id"
  end

  create_table "publications", force: :cascade do |t|
    t.string "title"
    t.text "abstract"
    t.date "publication_date"
    t.string "openalex_id"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "roboscout_queries", force: :cascade do |t|
    t.string "query"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0
  end

  create_table "roboscout_query_people", force: :cascade do |t|
    t.integer "roboscout_query_id", null: false
    t.integer "person_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["person_id"], name: "index_roboscout_query_people_on_person_id"
    t.index ["roboscout_query_id"], name: "index_roboscout_query_people_on_roboscout_query_id"
  end

  add_foreign_key "person_publications", "people"
  add_foreign_key "person_publications", "publications"
  add_foreign_key "roboscout_query_people", "people"
  add_foreign_key "roboscout_query_people", "roboscout_queries"
end
