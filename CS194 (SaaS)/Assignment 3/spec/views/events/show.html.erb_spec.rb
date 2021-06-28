require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/events/show.html.erb" do
  include EventsHelper
  
  before(:each) do
    assigns[:event] = @event = stub_model(Event,
              :title =>  "Washington VS. Cal",
              :description =>  "Washington Plays Cal",
              :telephone =>  "555-555-5555",
              :event_datetime =>  Time.now,
              :total_score =>  nil,
              :num_votes =>  nil,
              :summary =>  "Washington Cal",
              :street1 =>  "Stadium",
              :street2 =>  nil,
              :city =>  "Pullman",
              :state =>  "WA",
              :zip =>  "12345",
              :country =>  "USA",
              :latitude =>  47.650111111111,
              :longitude =>  -122.301525,
              :user => stub_model(User, :login => 'user'))
  end

  it "should render attributes in <p>" do
    render "/events/show.html.erb"
    response.should have_text(/Washington VS\. Cal/)
    response.should have_text(/Washington Plays Cal/)
    response.should have_text(/555-555-5555/)
    response.should have_text(/Washington Cal/)
    response.should have_text(/12345/)
    response.should have_text(/Pullman/)
    response.should have_text(/user/)
  end
end

