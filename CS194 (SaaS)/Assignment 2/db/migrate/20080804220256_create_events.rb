class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string "title", :limit => 100
      t.string "description", :limit => 500
      t.string "telephone", :limit => 20
      t.datetime "event_timestamp"
      t.date "event_date"
      t.integer "total_score"
      t.integer "num_votes"
      t.string "summary", :limit => 100
      t.string  "street1",   :limit => 55
      t.string  "street2",   :limit => 55
      t.string  "city",      :limit => 55
      t.string  "state",     :limit => 25
      t.string  "zip",       :limit => 12
      t.string  "country",   :limit => 55
      t.decimal "latitude",  :precision => 14, :scale => 10
      t.decimal "longitude", :precision => 14, :scale => 10
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
