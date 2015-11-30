require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
  fixtures :all

  def login_admin
    post_via_redirect login_path, session: { username: users(:one).username, password: '!password', remember_me: false }
    assert_equal 'Logged in successfully.', flash[:notice]
  end

  def login_normal
    post_via_redirect login_path, session: { username: users(:two).username, password: '!password', remember_me: false }
    assert_equal 'Logged in successfully.', flash[:notice]
  end

  test 'login and browse site' do
    get_via_redirect login_path
    assert_response :success

    login_normal

    get_via_redirect profile_path
    assert_response :success
  end

  # Test events
  test 'logged in and can submit event' do
    login_normal

    get_via_redirect new_event_path
    assert_response :success

    event = Event.first
    assert_difference 'Event.count' do
      post_via_redirect events_path, event: {
          Title: event.Title,
          Description: event.Description,
          Address: event.Address,
          Latitude: event.Latitude,
          Longitude: event.Longitude,
          Category: event.Category,
          StartDate: event.StartDate,
          StartTime: event.StartTime,
          EndDate: event.EndDate,
          EndTime: event.EndTime
      }
    end
  end

  test 'admin can view private event' do
    login_admin

    event = events(:newevent)

    get_via_redirect event_path(event)
    assert_response :success
  end

  test 'friend can view private event' do
    login_normal

    event = events(:admin_private)

    get_via_redirect event_path(event)
    assert_response :success
  end

  test 'unknown user can not view private event' do
    login_normal

    event = events(:notfriend_private)

    get_via_redirect event_path(event)

    assert_redirected_to root_path
    assert_equal "You don't have permission to view this event.", flash[:alert]
  end

  test 'admin can delete event' do
    login_admin

    event = events(:newevent)

    get_via_redirect event_path(event)
    assert_response :success

    assert_difference 'Event.count', -1 do
      delete_via_redirect event_path(event)
    end
  end

  # Test reports
  test 'not logged in cannot submit report' do
    post reports_path, report: {event_id: Event.first.id, description: 'Bad event!'}
    assert_equal 'You must be logged in to access this page.', flash[:alert]
  end

  test 'login and submit valid report' do
    login_admin

    get_via_redirect new_report_path, id: Event.first.id
    assert_response :success

    post reports_path, report: {event_id: Event.first.id, description: 'Bad event!'} #:format => 'json', 'report[description]' => 'Crap!', 'report[event_id]' => 1
    assert_equal 'Report successfully submitted.', flash[:notice]
  end

  test 'login and submit invalid report' do
    login_admin

    post_via_redirect reports_path, report: {event_id: Event.first.id, description: ''}
    assert_equal 'Unable to submit report.', flash[:notice]

    post_via_redirect reports_path, report: {event_id: 0, description: 'Yup!'}
    assert_equal 'Unable to submit report.', flash[:notice]
  end
end