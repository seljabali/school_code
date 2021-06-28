
Here's your first end-to-end Rails assignment. 

NOTE!  As always...DO NOT try to do the lab by starting to read and then
blindly typing as you go!  Read the whole thing first to understand the
big picture.  We do give you some hints for what to type, but learn to
use documentation and resources like the (online) books if something
doesn't appear to work exactly the first time.  You only learn to ride a
bicycle by falling off a few times...

* Overview

Last week you wrote an instance method for the Event class in our
bare-bones Event application.  This week you'll add some views and
controller methods for Events, and you'll also add a new model to the
application (Comments) along with its controller and views.  The idea is
that a single Event can have many comments associated with it, so Comment is a
separate model rather than a field of the Event model.  (Using the
terminology of ActiveRecord associations, which you'll learn about this
week, we would say 'an Event has_many Comments' and 'a Comment
belongs_to an Event.'

This will be your first end-to-end Rails web application and getting it
right can be a bit tricky. We suggest you think of the assignment in two
big chunks:

- First chunk: get the views and controller working for Events alone.
  Get the spec tests to pass for the Event model and views.

- Second chunk: add the Comments model, set up the association between
  Comments and Events, add the basic views for Comments, and modify the
  Event's views so that the comments are displayed along with each
  event.  Get all remaining spec tests to pass.

Each event can have many comments. The comments model will be very
simple (the migration is supplied as before) and only contain a
comment text field. The user can only view comments while viewing the
event to which the comments belong.

There are some complexities with regards to the multimodel
associations, so watch out.

HINT 1: BEFORE you start writing, read through all of the tests in the
spec/ directory to get a sense of what they will be testing for!

HINT 2: You're encouraged to "test as you go" to get little bits of
stuff working at a time.  'rake spec:models' will run only the model
tests; replacing 'models' with 'controllers' or 'views' will run only
the controller or view tests.  

HINT 3: Don't forget you can interact with your app as you go. 'ruby
script/server' will start a local Web server (usually on port 3000, but
you can override with '-p <portnumber>') and you can interact with your
app via a browser.  'ruby script/console' boots up your app and you can
manually activate its methods from the command line.

* Tasks - part 1 - CRUD the Events model
  
  1. Create a new rails application ('rails <appname>').  Change into
     the app's root directory (the one containing app/, public/, db/,
     etc.), usually referred to as $APP_ROOT.  All subsequent commands
     should be done from $APP_ROOT unless otherwise noted; if a command
     doesn't work, the first thing to check is make sure your current
     directory is $APP_ROOT.
  
  2. Unpack the zip file *inside* $APP_ROOT.  (When prompted, type 'A'
     for 'All' to allow the files in the zip archiv to overwrite the
     files created by running 'rails <appname>'.)

     unzip assignment2.zip

  3. MAKE SURE YOU HAVE A GOOD INSTALL OF RoR:
     Still in $APP_ROOT, type 'ruby script/console'.
     You should see: Loading development environment (Rails 2.1.1)
     If you see a different version or an error, you don't have Rails
     installed properly.  On Mac OS or Linux, you may be able to fix
     this by saying:
       > sudo gem update rails
       > sudo gem update rake
     If all looks well, type 'exit' to exit the console.
     Now type 'ruby --version'; you should be on Ruby 1.8.6 or later.
     
  4. Copy your app/models/Event.rb file (from assignment 1) to the
     app/models/ directory of this assignment; you'll be building on
     that code.

  5. Migrate your database to add the new Comment model and some other
     changes required for the tests to run.  (The migrations are included
     in the db/migrate/ subdirectory of the zip file.  Take a look to
     see what they do before you run them.)

     rake db:migrate

     This will apply *three* migrations to your database.

     ** NOTE! ** There may be some issues regarding the version of Rails
        that is "baked into" the zip file.  If your first and second
        migrations run OK but you get a "Table not found" error on the
        third one, you may be affected by this issue.  If that's the
        case, edit the file
        $(APP_ROOT)/vendor/rails/activerecord/lib/active_record/connection_adapters/ 
        go to line 28, and change the line as follows:

        ORIGINAL LINE:
        returning structure = @connection.table_info(quote_table_name(table_name)) do
        CHANGE IT TO:
        returning structure = @connection.table_info(table_name) do

        ONLY DO THIS if you have the EXACT problem described!!  If
        interested you can read about this at 
        http://rails.lighthouseapp.com/projects/8994/tickets/99-sqlite-connection-failing

  6. Add the necessary views and corresponding controller actions so
     that you can CRUD events.  That means you need actions and views
     for: index (list), show, edit, new.  

     HINT 1: Take a look in spec/views/event to see roughly what is expected.

     HINT 2: Since this is a simple model with only these actions, you can
     use 'script/generate scaffold ....' to help with the views and
     controller actions for you, as we showed in class on Tuesday.
     (In chunk 2 of the lab, you won't be able to scaffold so
     easily because of the association relationship between Events and
     Comments.) 

     HINT 3: If you didn't scaffold, you will have to manually add
     RESTful routes (in config/routes.rb) to connect URL's to the views,
     as discussed in class.

  6. At this point, all of the tests related to the Event model should
     pass when you run 'rake spec', but the tests related to the Comment
     model will still fail.

* Tasks - part 2 - add an associated Comments model

  1. Add a Comment model to the models directory. (You already added the
     corresponding table to the database when you ran the migration
     earlier.)  Be sure to create the necessary associations between the
     event and the comments - an event has many comments, and a comment
     belongs to one event.

  2. Now add the routing required in routes.rb for both the events and
     the associated comments.  These will be RESTful nested routes,
     since a comment can only be viewed/edited/deleted in the context of
     the event to which it belongs.  If you scaffolded in part 1 of the
     lab, you will have to modify a lot of the scaffolded code, since
     the scaffold didn't know about the association.
     
     NOTE: This step is particularly important to get right, because the
     URL helpers for your views rely on these routes as well.

  3. Modify the Event's views, and add views for Comments, so that the
     app flows as follows:

     a. The default view (when you access http://localhost:3000 or
        wherever your app is running, but you don't provide anything
        else in the URL) should be the events list. (HINT: Use map.root
        to do this. Read more about routes in RW ch3, which is required
        reading for next time anyway.)

     b. The events list will allow for the user to create a new event or
     	show, edit, and delete an existing event.

     c. The 'show event' page for an event will list all comments
     	associated with the event, and allow the user to add a new
     	comment and delete existing comments.  (HINT: You will have to
     	add URL helpers for the nested comment model to the 'show event'
     	page.  These URL helpers will again use the RESTful nested
     	routes that you added to routes.rb.)

     d. Adding or editing a comment will take the user to a new
     	page specifically for creating or editing that comment.  These
     	views can be 'plain vanilla' new & edit views - similar to the
     	ones you have for Events - but make sure you again use the URL
     	helpers that give you RESTful nested routes.

  4. Keep MVC in mind; test models, controllers, and views seperately with
     'rake spec:models', 'rake spec:controllers', and 'rake spec:views',
     respectively. 

     Likewise, you can test an invidiual spec with (e.g.) 'ruby
     spec/models/event_spec.rb', but if you do that, don't forget to run
     'rake db:test:prepare' first. (This is done automatically when you
     run 'rake spec' to do a whole suite of tests.)

 * Goal

Get all supplied Rspec tests to pass.
