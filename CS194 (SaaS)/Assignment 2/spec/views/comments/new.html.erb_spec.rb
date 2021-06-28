require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/comments/new.html.erb" do
  include CommentsHelper
  
  before(:each) do
    assigns[:event] = @event = stub_model(Event, :title => 'Test Event', :new_record? => false)
    assigns[:comment] = stub_model(Comment,
      :new_record? => true,
      :comment => "value for comment"
    )
  end

  it "should render new form" do
    render "/comments/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", event_comments_path(@event)) do
      with_tag("textarea#comment_comment[name=?]", "comment[comment]")
    end
  end
end


