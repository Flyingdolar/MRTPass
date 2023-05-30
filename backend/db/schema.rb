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

ActiveRecord::Schema[7.0].define(version: 2023_05_30_185124) do
  create_table "announcements", force: :cascade do |t|
    t.string "topic"
    t.text "context"
    t.integer "member_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_announcements_on_member_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string "photo"
    t.text "comment"
    t.integer "score"
    t.integer "member_id", null: false
    t.integer "info_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["info_id"], name: "index_comments_on_info_id"
    t.index ["member_id"], name: "index_comments_on_member_id"
  end

  create_table "infos", force: :cascade do |t|
    t.string "name"
    t.string "photo"
    t.string "address"
    t.string "type_"
    t.text "Des"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lines", force: :cascade do |t|
    t.string "linecolor"
    t.string "name"
    t.string "colorcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "logins", force: :cascade do |t|
    t.boolean "isLogin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "losts", force: :cascade do |t|
    t.string "item"
    t.string "photo"
    t.string "time"
    t.string "location"
    t.string "lost_Attr"
    t.integer "member_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_losts_on_member_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "account"
    t.string "password"
    t.string "nickname"
    t.string "role"
    t.string "picture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "member_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_sessions_on_member_id"
  end

  create_table "station_infos", force: :cascade do |t|
    t.integer "info_id", null: false
    t.integer "station_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["info_id"], name: "index_station_infos_on_info_id"
    t.index ["station_id"], name: "index_station_infos_on_station_id"
  end

  create_table "station_nos", force: :cascade do |t|
    t.string "linecolor"
    t.integer "number"
    t.integer "station_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["station_id"], name: "index_station_nos_on_station_id"
  end

  create_table "stations", force: :cascade do |t|
    t.float "x_Pos"
    t.float "y_Pos"
    t.integer "exit_Num"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.integer "price"
    t.float "upper_bound"
    t.float "lower_bound"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "time_tables", force: :cascade do |t|
    t.string "time"
    t.string "line"
    t.integer "end"
    t.integer "No"
    t.integer "station_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["station_id"], name: "index_time_tables_on_station_id"
  end

  add_foreign_key "announcements", "members"
  add_foreign_key "comments", "infos"
  add_foreign_key "comments", "members"
  add_foreign_key "losts", "members"
  add_foreign_key "sessions", "members"
  add_foreign_key "station_infos", "infos"
  add_foreign_key "station_infos", "stations"
  add_foreign_key "station_nos", "stations"
  add_foreign_key "time_tables", "stations"
end
