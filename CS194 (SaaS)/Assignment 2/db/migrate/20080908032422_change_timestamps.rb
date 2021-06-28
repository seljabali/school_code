class ChangeTimestamps < ActiveRecord::Migration
  def self.up
    rename_column :events, :event_timestamp, :event_datetime
    remove_column :events, :event_date
  end

  def self.down
    rename_column :events, :event_datetime, :event_timestamp
    add_column :events, :event_date, :date
  end
end
