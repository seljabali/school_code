require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/comments/edit.html.erb" do
  include CommentsHelper
  
  before(:each) do
    assigns[:event] = @event = stub_model(Event, :title => 'Test Event')
    assigns[:comment] = @comment = stub_model(Comment,
      :new_record? => false,
      :comment => "value for comment"
    )
  end

  it "should render edit form" do
    render "/comments/edit.html.erb"
    
    response.should have_tag("form[action=#{event_comment_path(@event, @comment)}][method=post]") do
      with_tag('textarea#comment_comment[name=?]', "comment[comment]")
    end
  end
end


