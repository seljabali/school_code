require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/events/index.html.erb" do
  include EventsHelper
  
  before(:each) do
    assigns[:events] = [
      stub_model(Event),
      stub_model(Event)
    ]
  end

  it "should render list of events" do
    render "/events/index.html.erb"
  end
end

