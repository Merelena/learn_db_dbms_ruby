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

ActiveRecord::Schema.define(version: 2021_04_24_080135) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "edu_aids", force: :cascade do |t|
    t.string "name", null: false
    t.string "authors", null: false
    t.string "publisher", null: false
    t.integer "publish_year", null: false
    t.string "document", null: false
    t.string "description"
    t.integer "number_of_pages"
    t.string "image", default: ""
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_edu_aids_on_user_id"
  end

  create_table "edu_institutions", force: :cascade do |t|
    t.string "edu_institution"
    t.string "city"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["edu_institution"], name: "index_edu_institutions_on_edu_institution", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "role", default: "student", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "middle_name", default: ""
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "edu_institution_id"
    t.string "authentication_token", limit: 30
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["edu_institution_id"], name: "index_users_on_edu_institution_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "edu_aids", "users"
  add_foreign_key "users", "edu_institutions"
end
