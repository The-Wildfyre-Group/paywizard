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

ActiveRecord::Schema.define(version: 20151222191144) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "guides", force: true do |t|
    t.string   "state"
    t.string   "name"
    t.string   "payer"
    t.string   "contact"
    t.string   "phone_number"
    t.string   "fax_number"
    t.boolean  "published_policies"
    t.string   "policy_name"
    t.string   "policy_number"
    t.string   "policy_link"
    t.text     "product_codes_covered"
    t.text     "approved_diagnoses"
    t.text     "approved_diagnoses_codes"
    t.text     "age_limitations"
    t.text     "other_limitations"
    t.boolean  "state_mandate_apply"
    t.boolean  "major_medical_benefit"
    t.boolean  "rx_benefit"
    t.boolean  "pa_required"
    t.boolean  "pa_form_required"
    t.string   "pa_link"
    t.text     "pa_process"
    t.text     "coverage_notes"
    t.text     "accepted_billing_codes"
    t.boolean  "bo_modifier"
    t.boolean  "is_s9433"
    t.string   "coding_link"
    t.string   "nutricia_formulary_products"
    t.string   "open_or_closed_formulary"
    t.boolean  "formulary_exception_allowed"
    t.boolean  "formulary_form_required"
    t.string   "formulary_link"
    t.boolean  "formulary_documentation_required"
    t.text     "formulary_process"
    t.boolean  "reimbursement_fee_schedule"
    t.string   "reimbursement_link"
    t.string   "product_reimbursement_rate"
    t.text     "reimbursement_specific"
    t.text     "reimbursement_methodology"
    t.string   "reimbursement_fees"
    t.string   "other_notes"
    t.text     "relationship_to_wic"
    t.text     "relationship_to_state_medicaid"
    t.text     "relationship_to_other_programs"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "guides", ["name"], name: "index_guides_on_name", using: :btree
  add_index "guides", ["payer"], name: "index_guides_on_payer", using: :btree
  add_index "guides", ["slug"], name: "index_guides_on_slug", using: :btree
  add_index "guides", ["state"], name: "index_guides_on_state", using: :btree

  create_table "users", force: true do |t|
    t.string   "password_digest",        default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "authentication_token"
    t.string   "slug"
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree

end
