require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CommentsController do
  fixtures :users

  def mock_comment(stubs={})
    @mock_comment ||= mock_model(Comment, stubs)
  end
  
  def mock_event(stubs={})
    @mock_event ||= mock_model(Event, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all comments as @comments" do
      request.env["HTTP_ACCEPT"] = "application/xml"
      Event.should_receive(:find).with("31").and_return(mock_event)
      mock_event.should_receive(:comments).and_return(comments = [mock_comment])
      comments.should_receive(:to_xml).and_return("generated XML")
      get :index, :event_id => "31"
      assigns[:comments].should == [mock_comment]
    end

    describe "with mime type html" do
      it "should fail to render" do
        request.env["HTTP_ACCEPT"] = "text/html"
        Event.should_receive(:find).with("31").and_return(mock_event)
        mock_event.should_receive(:comments).and_return(comments = [mock_comment])
        get :index, :event_id => "31"
        response.response_code.should == 406 # Unacceptable
      end
    end

    describe "with mime type of xml" do
      it "should render all comments as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Event.should_receive(:find).with("31").and_return(mock_event)
        mock_event.should_receive(:comments).and_return(comments = mock("Array of Comments"))
        comments.should_receive(:to_xml).and_return("generated XML")
        get :index, :event_id => "31"
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do
    it "should expose the requested comment as @comment" do
      Comment.should_receive(:find).with("37").and_return(mock_comment)
      Event.should_receive(:find).with("31").and_return(mock_event)
      get :show, :id => "37", :event_id => "31"
      assigns[:comment].should equal(mock_comment)
    end
    
    describe "with mime type html" do
      it "should fail to render" do
        request.env["HTTP_ACCEPT"] = "text/html"
        Event.should_receive(:find).with("31").and_return(mock_event)
        Comment.should_receive(:find).with("37").and_return(mock_comment)
        get :show, :id => "37", :event_id => "31"
        response.response_code.should == 406 # Unacceptable
      end
    end

    describe "with mime type of xml" do
      it "should render the requested comment as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Event.should_receive(:find).with("31").and_return(mock_event)
        Comment.should_receive(:find).with("37").and_return(mock_comment)
        mock_comment.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37", :event_id => "31"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
    it "should expose a new comment as @comment when logged in" do
      login_as(:quentin)
      Comment.should_receive(:new).and_return(mock_comment)
      Event.should_receive(:find).with("31").and_return(mock_event)
      get :new, :event_id => "31"
      assigns[:comment].should equal(mock_comment)
    end

    it "should not be allowed if not logged in" do
      get :new, :event_id => "31"
      response.should redirect_to(new_session_url)
    end
  end

  describe "responding to GET edit" do

    it "should expose the requested comment as @comment logged in" do
      login_as(:quentin)
      Comment.should_receive(:find).with("37").and_return(mock_comment(:user_id => users(:quentin).id))
      Event.should_receive(:find).with("31").and_return(mock_event)
      get :edit, :id => "37", :event_id => "31"
      assigns[:comment].should equal(mock_comment)
    end

    it "should not be allowed if not logged in" do
      get :edit, :id => "37", :event_id => "31"
      response.should redirect_to(new_session_url)
    end
    
    it "should not allow if not creator" do
      login_as(:aaron)
      Comment.stub!(:find).and_return(mock_comment(:update_attributes => true, :user_id => users(:quentin).id))
      get :edit, :id => "37", :event_id => "31"
      response.response_code.should == 401
      response.body.should =~ /You have insuffi(ci)?ent permissions/
    end
  end

  describe "responding to POST create" do
    describe "with valid params" do
      
      it "should expose a newly created comment as @comment" do
        login_as(:quentin)
        Comment.should_receive(:new).with({'these' => 'params'}).and_return(mock_comment(:save => true, :user_id => users(:quentin).id))
        Event.should_receive(:find).with("31").and_return(mock_event)
        mock_comment.should_receive(:'event=').with(mock_event)
        mock_comment.should_receive(:user=).with(users(:quentin))
        post :create, :comment => {:these => 'params'}, :event_id => "31"
        assigns(:comment).should equal(mock_comment)
      end

      it "should redirect to the event" do
        login_as(:quentin)
        Comment.stub!(:new).and_return(mock_comment(:save => true, :user_id => users(:quentin).id))
        Event.should_receive(:find).with("31").and_return(mock_event)
        mock_comment.should_receive(:'event=').with(mock_event)
        mock_comment.should_receive(:user=).with(users(:quentin))
        post :create, :comment => {}, :event_id => "31"
        response.should redirect_to(event_url(mock_event))
      end
      
      it "should not be allowed if not logged in" do
        post :create, :comment => {}, :event_id => "31"
        response.should redirect_to(new_session_url)
      end
    end
    
    describe "with invalid params" do
      before(:each) do
        login_as(:quentin)
      end
      
      it "should expose a newly created but unsaved comment as @comment" do
        Comment.stub!(:new).with({'these' => 'params'}).and_return(mock_comment(:save => false, :user_id => users(:quentin).id))
        Event.should_receive(:find).with("31").and_return(mock_event)
        mock_comment.should_receive(:'event=').with(mock_event)
        mock_comment.should_receive(:user=).with(users(:quentin))
        post :create, :comment => {:these => 'params'}, :event_id => "31"
        assigns(:comment).should equal(mock_comment)
      end

      it "should re-render the 'new' template" do
        Comment.stub!(:new).and_return(mock_comment(:save => false))
        Event.should_receive(:find).with("31").and_return(mock_event)
        mock_comment.should_receive(:'event=').with(mock_event)
        mock_comment.should_receive(:user=).with(users(:quentin))
        post :create, :comment => {}, :event_id => "31"
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do
    describe "with valid params" do

      it "should update the requested comment" do
        login_as(:quentin)
        Comment.should_receive(:find).with("37").and_return(mock_comment(:user_id => users(:quentin).id))
        Event.should_receive(:find).with("31").and_return(mock_event)
        mock_comment.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :comment => {:these => 'params'}, :event_id => "31"
      end

      it "should expose the requested comment as @comment" do
        login_as(:quentin)
        Comment.stub!(:find).and_return(mock_comment(:update_attributes => true, :user_id => users(:quentin).id))
        Event.should_receive(:find).with("31").and_return(mock_event)
        put :update, :id => "1", :event_id => "31"
        assigns(:comment).should equal(mock_comment)
      end

      it "should redirect to the event" do
        login_as(:quentin)
        Comment.stub!(:find).and_return(mock_comment(:update_attributes => true, :user_id => users(:quentin).id))
        Event.should_receive(:find).with("31").and_return(mock_event)
        put :update, :id => "1", :event_id => "31"
        response.should redirect_to(event_url(mock_event))
      end

      it "should not be allowed if not logged in" do
        put :update, :id => "1", :event_id => "31"
        response.should redirect_to(new_session_url)
      end
      
      it "should not allow if not creator" do
        login_as(:aaron)
        Comment.stub!(:find).and_return(mock_comment(:update_attributes => true, :user_id => users(:quentin).id))
        put :update, :id => "1", :event_id => "31"
        response.response_code.should == 401
        response.body.should =~ /You have insuffi(ci)?ent permissions/
      end
    end
    
    describe "with invalid params" do
      before(:each) do
        login_as(:quentin)
      end

      it "should update the requested comment" do
        Comment.should_receive(:find).with("37").and_return(mock_comment(:user_id => users(:quentin).id))
        Event.should_receive(:find).with("31").and_return(mock_event)
        mock_comment.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :comment => {:these => 'params'}, :event_id => "31"
      end

      it "should expose the comment as @comment" do
        Comment.stub!(:find).and_return(mock_comment(:update_attributes => false, :user_id => users(:quentin).id))
        Event.should_receive(:find).with("31").and_return(mock_event)
        put :update, :id => "1", :event_id => "31"
        assigns(:comment).should equal(mock_comment)
      end

      it "should re-render the 'edit' template" do
        Comment.stub!(:find).and_return(mock_comment(:update_attributes => false, :user_id => users(:quentin).id))
        Event.should_receive(:find).with("31").and_return(mock_event)
        put :update, :id => "1", :event_id => "31"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do
    it "should destroy the requested comment" do
      login_as(:quentin)
      Comment.should_receive(:find).with("37").and_return(mock_comment(:event => mock_event, :user_id => users(:quentin).id))
      Event.stub!(:find).with("31").and_return(mock_event)
      mock_comment.should_receive(:destroy)
      delete :destroy, :id => "37", :event_id => "31"
    end
  
    it "should redirect to the event" do
      login_as(:quentin)
      Comment.should_receive(:find).and_return(mock_comment(:destroy => true, :event => mock_event, :user_id => users(:quentin).id))
      Event.stub!(:find).with("31").and_return(mock_event)
      delete :destroy, :id => "1", :event_id => "31"
      response.should redirect_to(event_url(mock_event))
    end

    it "should not be allowed if not logged in" do
      delete :destroy, :id => "1", :event_id => mock_event.id
      response.should redirect_to(new_session_url)
    end
    
    it "should not allow if not creator" do
      login_as(:aaron)
      Comment.should_receive(:find).and_return(mock_comment(:destroy => true, :event => mock_event, :user_id => users(:quentin).id))
      Event.stub!(:find).with("31").and_return(mock_event)
      delete :destroy, :id => "1", :event_id => "31"
      response.response_code.should == 401
      response.body.should =~ /You have insuffi(ci)?ent permissions/
    end
  end

end
