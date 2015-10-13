require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  setup do
    @event = events(:one)
    @newevent = Event.new(Title: "New Event", Latitude: 15.123456, Longitude: 90.123456, Description: "A new event.", Category: "Party", Day: 15, Month: 6, Year: 2016 )
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:events)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create event" do
    assert_difference('Event.count') do
      post :create, event: { Category: @event.Category, Day: @event.Day, Description: @event.Description, Latitude: @event.Latitude, Longitude: @event.Longitude, Month: @event.Month, Title: @event.Title, Year: @event.Year }
    end

    assert_redirected_to event_path(assigns(:event))
  end

  test "should show event" do
    get :show, id: @event
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @event
    assert_response :success
  end

  test "should update event" do
    patch :update, id: @event, event: { Category: @event.Category, Day: @event.Day, Description: @event.Description, Latitude: @event.Latitude, Longitude: @event.Longitude, Month: @event.Month, Title: @event.Title, Year: @event.Year }
    assert_redirected_to event_path(assigns(:event))
  end

  test "should destroy event" do
    assert_difference('Event.count', -1) do
      delete :destroy, id: @event
    end

    assert_redirected_to events_path
  end
  
  # Our created tests
  
  test "should be valid" do
    assert @newevent.valid?
  end
  
  test "event title should be <= 20 chars and > 0 chars" do
    @newevent.Title = "a" * 25
    assert_not @newevent.valid?
    @newevent.Title = ""
    assert_not @newevent.valid?
  end
  
  test "event description should <= 140 chars" do
    @newevent.Description = "a" * 200
    assert_not @newevent.valid?
  end
  
  test "event day should be <= 31 and > 0" do
    @newevent.Day = 32
    assert_not @newevent.valid?
    @newevent.Day = -1
    assert_not @newevent.valid?
  end
  
end
