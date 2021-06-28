require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/layouts/application.html.erb" do
  include ApplicationHelper
  
  it "should render the layout when not logged in" do
    render "/layouts/application.html.erb"
    response.should have_text(/Not logged in/)
    response.should have_text(/Log in/)
    response.should have_text(/Sign up/)
  end
  
  it "should render layout when logged in" do
    assigns[:current_user] = stub_model(User, :login => 'user_login')
    render "/layouts/application.html.erb"
    response.should have_text(/Logged in as/)
    response.should have_text(/user_login/)
    response.should have_text(/Log out/)
  end
end
