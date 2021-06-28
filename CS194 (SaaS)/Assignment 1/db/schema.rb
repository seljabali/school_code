# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080804220256) do

  create_table "events", :force => true do |t|
    t.string   "title",           :limit => 100
    t.string   "description",     :limit => 500
    t.string   "telephone",       :limit => 20
    t.datetime "event_timestamp"
    t.date     "event_date"
    t.integer  "total_score"
    t.integer  "num_votes"
    t.string   "summary",         :limit => 100
    t.string   "street1",         :limit => 55
    t.string   "street2",         :limit => 55
    t.string   "city",            :limit => 55
    t.string   "state",           :limit => 25
    t.string   "zip",             :limit => 12
    t.string   "country",         :limit => 55
    t.decimal  "latitude",                       :precision => 14, :scale => 10
    t.decimal  "longitude",                      :precision => 14, :scale => 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
