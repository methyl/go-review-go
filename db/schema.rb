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

ActiveRecord::Schema.define(version: 20140207082352) do

  create_table "commits", force: true do |t|
    t.string   "sha"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "author_id"
    t.integer  "committer_id"
    t.datetime "timestamp"
    t.text     "message"
  end

  add_index "commits", ["author_id"], name: "index_commits_on_author_id", using: :btree
  add_index "commits", ["committer_id"], name: "index_commits_on_committer_id", using: :btree

  create_table "people", force: true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
