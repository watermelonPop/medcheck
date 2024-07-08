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

ActiveRecord::Schema[7.1].define(version: 2024_07_05_000858) do
  create_table "day_takens", force: :cascade do |t|
    t.string "date"
    t.boolean "taken"
    t.integer "user_id", null: false
    t.integer "medication_schedule_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medication_schedule_id"], name: "index_day_takens_on_medication_schedule_id"
    t.index ["user_id"], name: "index_day_takens_on_user_id"
  end

  create_table "medication_schedules", force: :cascade do |t|
    t.time "time"
    t.string "day_of_week"
    t.boolean "taken"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "medication_id"
  end

  create_table "medications", force: :cascade do |t|
    t.string "name"
    t.decimal "dose_amount"
    t.string "dose_unit"
    t.integer "amount_taken"
    t.integer "amount_left"
    t.date "last_picked_up"
    t.string "icon"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["name"], name: "index_medications_on_name"
  end

  create_table "themes", force: :cascade do |t|
    t.string "name"
    t.string "main_background"
    t.string "schedule_background"
    t.string "medication_background"
    t.string "medication_main"
    t.string "heading"
    t.string "font"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uid"
    t.string "provider"
    t.integer "current_theme_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "day_takens", "medication_schedules"
  add_foreign_key "day_takens", "users"
  add_foreign_key "medication_schedules", "medications"
  add_foreign_key "medications", "users"
end
