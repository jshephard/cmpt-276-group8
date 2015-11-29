require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  setup do
    @event = events(:newevent)
    @privateevent = events(:private)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create event" do
    assert_difference('Event.count') do
      post :create, event: { Category: @event.Category,
                             StartDate: @event.StartDate,
                             EndDate: @event.EndDate,
                             StartTime: @event.StartTime,
                             EndTime: @event.EndTime,
                             Address: @event.Address,
                             Description: @event.Description,
                             Latitude: @event.Latitude,
                             Longitude: @event.Longitude,
                             Title: @event.Title,
                             id_private: false }
    end

    assert_redirected_to event_path(assigns(:event))
  end

  test "should show public event" do
    get :show, id: @event
    assert_response :success
  end

  test "should not show private event" do
    get :show, id: @privateevent
    assert_redirected_to root_path
  end

  test "should not get edit" do
    get :edit, id: @event
    assert_redirected_to login_path
  end

  test "should not update event" do
    # Not logged in, can not edit/delete events.
    patch :update, id: @event, event: { Category: @event.Category,
                                        StartDate: @event.StartDate,
                                        EndDate: @event.EndDate,
                                        StartTime: @event.StartTime,
                                        EndTime: @event.EndTime,
                                        Description: @event.Description,
                                        Latitude: @event.Latitude,
                                        Longitude: @event.Longitude,
                                        Title: @event.Title,
                                        id_private: @event.id_private }
    assert_redirected_to login_path # event_path(assigns(:event))
  end

  test "should not destroy event" do
    # As we are not logged in, event will not be destroyed
    assert_difference('Event.count', 0) do
      delete :destroy, id: @event
    end

    assert_redirected_to login_path
  end
  
end
