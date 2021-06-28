require File.dirname(__FILE__) + '/../spec_helper'

describe Event do
  fixtures :events, :comments, :users
  
  before(:each) do
    @valid_attributes = {
      :user => users(:quentin),
      :title => "Title",
      :summary => "Summary",
      :description => "Description",
      :telephone => "555-555-5555",
      :event_datetime => Time.now,
      :street1 => 'Street1',
      :city => 'City',
      :state => 'CA',
      :zip => '12345',
      :country => 'USA'
    }
    @event = Event.new(@valid_attributes)
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
  
  it "should have comments" do
    event = Event.find(1)
    event.should_not be_nil
    
    event.comments.should have(2).records
  end
  
  describe "has the following fields and" do
    def create_event(attributes, remove = nil)
      if remove
         attributes = attributes.dup
         attributes.delete(remove)
       end
      Event.new(attributes)
    end
    
    it "should have a title" do
      event = create_event(@valid_attributes, :title)
      event.should_not be_valid
      event.errors.on(:title).should == 'can\'t be blank'
    end
    
    it "should have a valid title" do
      event = create_event(@valid_attributes.merge(:title => 'a' * 101))
      event.should_not be_valid
      event.errors.on(:title).should == 'is too long (maximum is 100 characters)'
      event.title = 'a' * 100
      event.should be_valid      
    end
    
    it "should have a summary" do
      event = create_event(@valid_attributes, :summary)
      event.should_not be_valid
      event.errors.on(:summary).should == 'can\'t be blank'
    end
    
    it "should have a valid summary" do
      event = create_event(@valid_attributes.merge(:summary => 'a' * 101))
      event.should_not be_valid
      event.errors.on(:summary).should == 'is too long (maximum is 100 characters)'
      event.summary = 'a' * 100
      event.should be_valid      
    end
    
    it "should have a description" do
      event = create_event(@valid_attributes, :description)
      event.should_not be_valid
      event.errors.on(:description).should == 'can\'t be blank'
    end
    
    it "should have a valid description" do
      event = create_event(@valid_attributes.merge(:description => 'a' * 501))
      event.should_not be_valid
      event.errors.on(:description).should == 'is too long (maximum is 500 characters)'
      event.description = 'a' * 500
      event.should be_valid      
    end
    
    it "should have a telephone number" do
      event = create_event(@valid_attributes, :telephone)
      event.should_not be_valid
      event.errors.on(:telephone).should == 'can\'t be blank'
    end
    
    it "should have a valid telephone number" do
      event = create_event(@valid_attributes.merge(:telephone => 'a' * 10))
      event.should_not be_valid
      event.errors.on(:telephone).should == 'is invalid'
      
      event.telephone = '555-aaa'
      event.should_not be_valid
      event.errors.on(:telephone).should == 'is invalid'

      event.telephone = '555-555'
      event.should be_valid

      event.telephone = '555-555-5555'
      event.should be_valid
    end
    
    it "should have a street" do
      event = create_event(@valid_attributes, :street1)
      event.should_not be_valid
      event.errors.on(:street1).should == 'can\'t be blank'
    end
    
    it "should have a city" do
      event = create_event(@valid_attributes, :city)
      event.should_not be_valid
      event.errors.on(:city).should == 'can\'t be blank'
    end
    
    it "should have a state" do
      event = create_event(@valid_attributes, :state)
      event.should_not be_valid
      event.errors.on(:state).should == 'can\'t be blank'
    end
    
    it "should have a zip" do
      event = create_event(@valid_attributes, :zip)
      event.should_not be_valid
      event.errors.on(:zip).should == 'can\'t be blank'
    end
    
    it "should have a valid zip" do
      event = create_event(@valid_attributes.merge(:zip => 'a' * 10))
      event.should_not be_valid
      event.errors.on(:zip).should == 'is invalid'
      
      event.zip = '1234'
      event.should_not be_valid
      event.errors.on(:zip).should == 'is invalid'

      event.zip = '12345'
      event.should be_valid
    end
    
    it "should have a valid zip+4" do
      event = create_event(@valid_attributes)
      event.zip = '12345-1'
      event.should_not be_valid
      event.errors.on(:zip).should == 'is invalid'

      event.zip = '12345-a'
      event.should_not be_valid
      event.errors.on(:zip).should == 'is invalid'

      event.zip = '12345678'
      event.should_not be_valid
      event.errors.on(:zip).should == 'is invalid'

      event.zip = '12345-1234'
      event.should be_valid
    end

    it "should have a country" do
      event = create_event(@valid_attributes, :country)
      event.should_not be_valid
      event.errors.on(:country).should == 'can\'t be blank'      
    end
    
    it "should have a user" do
      event = create_event(@valid_attributes, :user)
      event.should_not be_valid
      event.errors.on(:user).should == 'can\'t be blank'      
    end
  end
end
