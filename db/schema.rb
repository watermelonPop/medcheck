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

ActiveRecord::Schema[7.1].define(version: 2024_02_18_062935) do
  create_table "day_of_weeks", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medication_schedules", force: :cascade do |t|
    t.integer "medication_id", null: false
    t.integer "day_of_week_id", null: false
    t.time "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["day_of_week_id"], name: "index_medication_schedules_on_day_of_week_id"
    t.index ["medication_id"], name: "index_medication_schedules_on_medication_id"
  end

  create_table "medications", force: :cascade do |t|
    t.string "name"
    t.integer "amount_taken"
    t.integer "amount_left"
    t.date "last_picked_up"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "dose_amount"
    t.string "dose_unit"
    t.integer "user_id", null: false
    t.string "day_of_week"
    t.string "time"
    t.index ["user_id"], name: "index_medications_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uid"
    t.string "provider"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "medication_schedules", "day_of_weeks"
  add_foreign_key "medication_schedules", "medications"
  add_foreign_key "medications", "users"
end
