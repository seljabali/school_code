require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Comment do
  fixtures :events, :comments, :users
  
  before(:each) do
    @valid_attributes = {
      :event => events(:one),
      :comment => "value for comment",
      :user => users(:quentin)
    }
  end

  it "should create a new instance given valid attributes" do
    Comment.create!(@valid_attributes)
  end
  
  it "should belong to a comment" do
    comment = Comment.find(1)
    comment.event.should_not be_nil
  end
  describe "has the following fields and" do
    def create_comment(attributes, remove = nil)
      if remove
         attributes = attributes.dup
         attributes.delete(remove)
       end
      Comment.new(attributes)
    end
    
    it "should have an event" do
      event = create_comment(@valid_attributes, :event)
      event.should_not be_valid
      event.errors.on(:event).should == 'can\'t be blank'      
    end
    
    it "should have a user" do
      event = create_comment(@valid_attributes, :user)
      event.should_not be_valid
      event.errors.on(:user).should == 'can\'t be blank'      
    end
    
    it "should have a comment" do
      event = create_comment(@valid_attributes, :comment)
      event.should_not be_valid
      event.errors.on(:comment).should == 'can\'t be blank'      
    end
  end
end
