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

ActiveRecord::Schema.define(version: 2021_11_07_034606) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clips", force: :cascade do |t|
    t.boolean "is_finished"
    t.boolean "is_published"
    t.string "video_filename"
    t.time "clip_starttime"
    t.time "clip_endtime"
    t.boolean "is_podcast"
    t.datetime "podcast_pub_datetime"
    t.string "podcast_title"
    t.text "podcast_desc"
    t.string "podcast_teaser_filename"
    t.time "podcast_teaser_starttime"
    t.time "podcast_teaser_endtime"
    t.boolean "is_youtube"
    t.datetime "youtube_pub_datetime"
    t.string "youtube_title"
    t.text "youtube_desc"
    t.string "youtube_thumbnail_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
