require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/events/new.html.erb" do
  include EventsHelper
  
  before(:each) do
    assigns[:event] = stub_model(Event,
      :new_record? => true,
      :title => 'A title',
      :summary => 'An event summary',
      :description => 'An event description',
      :telephone => '555-555-5555',
      :event_datetime => DateTime.parse('5:15 10/10/2008'),
      :street1 => '100 Main st.',
      :street2 => 'Apt b',
      :city => 'Berkeley',
      :state => 'CA',
      :zip => '94704',
      :country => 'USA'      
    )
  end

  it "should render new form" do
    render "/events/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", events_path) do
      with_tag("input#event_title[name=?]", "event[title]")
      with_tag("textarea#event_summary[name=?]", "event[summary]")
      with_tag("textarea#event_description[name=?]", "event[description]")
      with_tag("input#event_telephone[name=?]", "event[telephone]")
      with_tag("select#event_event_datetime_1i[name=?]", "event[event_datetime(1i)]")
      with_tag("select#event_event_datetime_2i[name=?]", "event[event_datetime(2i)]")
      with_tag("select#event_event_datetime_3i[name=?]", "event[event_datetime(3i)]")
      with_tag("select#event_event_datetime_4i[name=?]", "event[event_datetime(4i)]")
      with_tag("select#event_event_datetime_5i[name=?]", "event[event_datetime(5i)]")
      with_tag("input#event_street1[name=?]", "event[street1]")
      with_tag("input#event_street2[name=?]", "event[street2]")
      with_tag("input#event_city[name=?]", "event[city]")
      with_tag("input#event_state[name=?]", "event[state]")
      with_tag("input#event_zip[name=?]", "event[zip]")
      with_tag("input#event_country[name=?]", "event[country]")
    end
  end
end


