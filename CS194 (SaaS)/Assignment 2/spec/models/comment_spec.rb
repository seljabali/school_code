require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Comment do
  fixtures :events, :comments
  
  before(:each) do
    @valid_attributes = {
      :event_id => "1",
      :comment => "value for comment"
    }
  end

  it "should create a new instance given valid attributes" do
    Comment.create!(@valid_attributes)
  end
  
  it "should belong to a comment" do
    comment = Comment.find(1)
    comment.event.should_not be_nil
  end
end
