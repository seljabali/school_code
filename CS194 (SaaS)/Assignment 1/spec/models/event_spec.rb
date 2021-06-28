require File.dirname(__FILE__) + '/../spec_helper'

describe Event do
  fixtures :events
  
  before(:each) do
    @event = Event.new
  end

  it "should be valid" do
    @event.should be_valid
  end

  it "should compute distance to event" do
    event = Event.find(1)
    event.should_not be_nil
    event.distance(-122.258577777778, 37.87555).should be_close(1084.65, 10)

    event = Event.find(2)
    event.should_not be_nil
    event.distance(-122.258577777778, 37.87555).should be_close(3932.73, 10)

    event = Event.find(3)
    event.should_not be_nil
    event.distance(-122.258577777778, 37.87555).should be_close(1204.38, 10)

    event = Event.find(4)
    event.should_not be_nil
    event.distance(-122.258577777778, 37.87555).should be_close(0.87, 0.1)    
  end

  it "should find events in order of distance" do
    Event.find_ordered_by_distance_from(-122.258577777778, 37.87555).map do |e|
      e.id
    end.should == [4, 1, 3, 2]
  end
end
