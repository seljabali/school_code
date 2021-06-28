require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/comments/show.html.erb" do
  include CommentsHelper
  
  before(:each) do
    assigns[:event] = @event = stub_model(Event, :title => 'Test Event')
    assigns[:comment] = @comment = stub_model(Comment,
      :comment => "value for comment"
    )
  end

  it "should render attributes in <p>" do
    render "/comments/show.html.erb"
    response.should have_text(/value\ for\ comment/)
  end
end

