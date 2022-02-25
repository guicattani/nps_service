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

ActiveRecord::Schema.define(version: 2022_02_23_205128) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # These are custom enum types that must be created before they can be used in the schema definition
  create_enum "object_class_type", ["Pending", "HomedayService", "Realtor"]
  create_enum "respondent_class_type", ["Pending", "Buyer", "Seller"]
  create_enum "touchpoint_type", ["pending", "homeday_service_feedback", "realtor_feedback"]

  create_table "net_promoter_scores", force: :cascade do |t|
    t.integer "score"
    t.string "type"
    t.string "token", null: false
    t.enum "touchpoint", default: "pending", as: "touchpoint_type"
    t.enum "respondent_class", default: "Pending", as: "respondent_class_type"
    t.enum "object_class", default: "Pending", as: "object_class_type"
    t.bigint "respondent_id"
    t.bigint "object_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["object_id", "object_class"], name: "unique_object", unique: true
    t.index ["respondent_id", "respondent_class"], name: "unique_respondent", unique: true
    t.index ["touchpoint", "respondent_id", "respondent_class", "object_id", "object_class"], name: "unique_touchpoint", unique: true
    t.check_constraint "score = ANY (ARRAY[NULL::integer, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10])", name: "check_score_decimal_scale"
  end

end
