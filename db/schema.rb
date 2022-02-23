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

ActiveRecord::Schema[7.0].define(version: 2022_02_23_192632) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # These are custom enum types that must be created before they can be used in the schema definition
  create_enum "object_class_type", pending,realtor
  create_enum "respondent_class_type", pending,seller
  create_enum "touchpoint_type", pending,realtor_feedback

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "object_class_type", ["pending", "realtor"]
  create_enum "respondent_class_type", ["pending", "seller"]
  create_enum "touchpoint_type", ["pending", "realtor_feedback"]

  create_table "net_promoter_scores", force: :cascade do |t|
    t.integer "score"
    t.enum "touchpoint", default: "pending", enum_type: "touchpoint_type", as: "touchpoint_type"
    t.enum "respondent_class", default: "pending", enum_type: "respondent_class_type", as: "respondent_class_type"
    t.bigint "respondent_id"
    t.enum "object_class", default: "pending", enum_type: "object_class_type", as: "object_class_type"
    t.bigint "object_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["object_id"], name: "index_net_promoter_scores_on_object_id", unique: true
    t.index ["respondent_id"], name: "index_net_promoter_scores_on_respondent_id", unique: true
    t.check_constraint "score = ANY (ARRAY[NULL::integer, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10])", name: "check_score_decimal_scale"
  end

end
