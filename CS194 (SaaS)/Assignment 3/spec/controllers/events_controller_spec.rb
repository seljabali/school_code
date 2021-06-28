require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EventsController do
  fixtures :users

  def mock_event(stubs={})
    @mock_event ||= mock_model(Event, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all events as @events" do
      Event.should_receive(:find).with(:all).and_return([mock_event])
      get :index
      assigns[:events].should == [mock_event]
    end

    describe "with mime type of xml" do
  
      it "should render all events as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Event.should_receive(:find).with(:all).and_return(events = mock("Array of Events"))
        events.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested event as @event" do
      Event.should_receive(:find).with("37").and_return(mock_event)
      get :show, :id => "37"
      assigns[:event].should equal(mock_event)
    end
    
    describe "with mime type of xml" do

      it "should render the requested event as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Event.should_receive(:find).with("37").and_return(mock_event)
        mock_event.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
    it "should expose a new event as @event" do
      login_as(:quentin)
      Event.should_receive(:new).and_return(mock_event)
      get :new
      assigns[:event].should equal(mock_event)
    end
    
    it "should not be allowed if not logged in" do
      get :new
      response.should redirect_to(new_session_url)
    end
  end

  describe "responding to GET edit" do
    it "should expose the requested event as @event" do
      login_as(:quentin)
      Event.should_receive(:find).with("37").and_return(mock_event(:user_id => users(:quentin).id))
      get :edit, :id => "37"
      assigns[:event].should equal(mock_event)
    end
    
    it "should not be allowed if not logged in" do
      get :edit, :id => "37"
      response.should redirect_to(new_session_url)
    end
    
    it "should not allow if not creator" do
      login_as(:aaron)
      Event.stub!(:find).and_return(mock_event(:destroy => true, :user_id => users(:quentin).id))
      get :edit, :id => "37"
      response.response_code.should == 401
      response.body.should =~ /You have insuffi(ci)?ent permissions/
    end
  end

  describe "responding to POST create" do
    describe "with valid params" do
      
      it "should expose a newly created event as @event" do
        login_as(:quentin)
        Event.should_receive(:new).with({'these' => 'params'}).and_return(mock_event(:save => true))
        mock_event.should_receive(:user=).with(users(:quentin))
        
        post :create, :event => {:these => 'params'}
        assigns(:event).should equal(mock_event)
      end

      it "should redirect to the created event" do
        login_as(:quentin)
        Event.stub!(:new).and_return(mock_event(:save => true))
        mock_event.should_receive(:user=).with(users(:quentin))
        post :create, :event => {}
        response.should redirect_to(event_url(mock_event))
      end
      
      it "should not be allowed if not logged in" do
        post :create, :event => {}
        response.should redirect_to(new_session_url)
      end
    end
    
    describe "with invalid params" do
      before(:each) do
        login_as(:quentin)
      end

      it "should expose a newly created but unsaved event as @event" do
        Event.stub!(:new).with({'these' => 'params'}).and_return(mock_event(:save => false))
        mock_event.should_receive(:user=).with(users(:quentin))
        post :create, :event => {:these => 'params'}
        assigns(:event).should equal(mock_event)
      end

      it "should re-render the 'new' template" do
        Event.stub!(:new).and_return(mock_event(:save => false))
        mock_event.should_receive(:user=).with(users(:quentin))
        post :create, :event => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do
    describe "with valid params" do

      it "should update the requested event" do
        login_as(:quentin)
        Event.should_receive(:find).with("37").and_return(mock_event(:user_id => users(:quentin).id))
        mock_event.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :event => {:these => 'params'}
      end

      it "should expose the requested event as @event" do
        login_as(:quentin)
        Event.stub!(:find).and_return(mock_event(:update_attributes => true, :user_id => users(:quentin).id))
        put :update, :id => "1"
        assigns(:event).should equal(mock_event)
      end

      it "should redirect to the event" do
        login_as(:quentin)
        Event.stub!(:find).and_return(mock_event(:update_attributes => true, :user_id => users(:quentin).id))
        put :update, :id => "1"
        response.should redirect_to(event_url(mock_event))
      end

      it "should not be allowed if not logged in" do
        put :update, :id => "1"
        response.should redirect_to(new_session_url)
      end
      
      it "should not allow if not creator" do
        login_as(:aaron)
        Event.stub!(:find).and_return(mock_event(:destroy => true, :user_id => users(:quentin).id))
        put :update, :id => "1"
        response.response_code.should == 401
        response.body.should =~ /You have insuffi(ci)?ent permissions/
      end
    end
    
    describe "with invalid params" do
      before(:each) do
        login_as(:quentin)
      end

      it "should update the requested event" do
        Event.should_receive(:find).with("37").and_return(mock_event(:user_id => users(:quentin).id))
        mock_event.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :event => {:these => 'params'}
      end

      it "should expose the event as @event" do
        Event.stub!(:find).and_return(mock_event(:update_attributes => false, :user_id => users(:quentin).id))
        put :update, :id => "1"
        assigns(:event).should equal(mock_event)
      end

      it "should re-render the 'edit' template" do
        Event.stub!(:find).and_return(mock_event(:update_attributes => false, :user_id => users(:quentin).id))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "responding to DELETE destroy" do
    it "should destroy the requested event" do
      login_as(:quentin)
      Event.should_receive(:find).with("37").and_return(mock_event(:user_id => users(:quentin).id))
      mock_event.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the events list" do
      login_as(:quentin)
      Event.stub!(:find).and_return(mock_event(:destroy => true, :user_id => users(:quentin).id))
      delete :destroy, :id => "1"
      response.should redirect_to(events_url)
    end
    
    it "should not allow if not creator" do
      login_as(:aaron)
      Event.stub!(:find).and_return(mock_event(:destroy => true, :user_id => users(:quentin).id))
      delete :destroy, :id => "1"
      response.response_code.should == 401
      response.body.should =~ /You have insuffi(ci)?ent permissions/
    end

    it "should not be allowed if not logged in" do
      delete :destroy, :id => "1"
      response.should redirect_to(new_session_url)
    end
    
    
  end

end
