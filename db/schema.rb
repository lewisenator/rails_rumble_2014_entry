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

ActiveRecord::Schema.define(version: 20141019222703) do

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "auth"
    t.string   "email"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "movies", force: true do |t|
    t.string   "title"
    t.integer  "year"
    t.string   "imdb_id"
    t.string   "rated"
    t.date     "released"
    t.string   "runtime"
    t.text     "genre"
    t.text     "director"
    t.text     "writer"
    t.text     "actors"
    t.text     "plot"
    t.string   "poster"
    t.string   "imdb_rating"
    t.integer  "imdb_votes"
    t.integer  "metascore"
    t.string   "language"
    t.string   "country"
    t.text     "awards"
    t.string   "tomato_rating"
    t.string   "production"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "movie_type"
    t.string   "poster_image_file_name"
    t.string   "poster_image_content_type"
    t.integer  "poster_image_file_size"
    t.datetime "poster_image_updated_at"
  end

  create_table "user_movie_joins", force: true do |t|
    t.integer  "user_id"
    t.integer  "movie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "your_rating"
    t.boolean  "in_library"
  end

  add_index "user_movie_joins", ["movie_id"], name: "index_user_movie_joins_on_movie_id", using: :btree
  add_index "user_movie_joins", ["user_id"], name: "index_user_movie_joins_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
