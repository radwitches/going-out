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

ActiveRecord::Schema.define(version: 20160730101320) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "hstore"

  create_table "amenities", force: :cascade do |t|
    t.geometry "point",    limit: {:srid=>4283, :type=>"point"}
    t.string   "icon",                                           default: "", null: false
    t.string   "icon_alt",                                       default: "", null: false
    t.hstore   "extras",                                         default: {}, null: false
    t.index ["point"], name: "index_amenities_on_point", using: :gist
  end

  create_table "destination_amenities", force: :cascade do |t|
    t.integer "destination_id", null: false
    t.integer "amenity_id",     null: false
  end

  create_table "destinations", primary_key: "gid", force: :cascade do |t|
    t.decimal  "park_reser"
    t.string   "name",       limit: 254
    t.date     "establishm"
    t.decimal  "total_park"
    t.string   "area_type",  limit: 254
    t.string   "style_type", limit: 50
    t.decimal  "shape_leng"
    t.decimal  "shape_area"
    t.geometry "geom",       limit: {:srid=>4283, :type=>"multi_polygon"}
    t.index ["geom"], name: "index_destinations_on_geom", using: :gist
  end

end
