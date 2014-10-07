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

ActiveRecord::Schema.define(version: 20141007130119) do

  create_table "fips_county_fips_codes", force: true do |t|
    t.integer  "fips_state_fips_code_id"
    t.string   "county_name"
    t.string   "fips_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fips_state_fips_codes", force: true do |t|
    t.string   "state_name"
    t.string   "state_abbr"
    t.string   "fips_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fips_zip_codes", force: true do |t|
    t.integer  "fips_state_fips_code_id"
    t.integer  "fips_county_fips_code_id"
    t.string   "zip"
    t.string   "zip_type"
    t.string   "primary_city"
    t.string   "acceptable_cities"
    t.string   "unacceptable_cities"
    t.string   "state"
    t.string   "county"
    t.string   "timezone"
    t.string   "area_codes"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "world_region"
    t.string   "country"
    t.integer  "decommissioned"
    t.integer  "estimated_population"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
