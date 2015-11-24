require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
  fixtures :all

  def login
    post_via_redirect login_path, session: { username: users(:one).username, password: '!password', remember_me: false }
    assert_equal 'Logged in successfully.', flash[:notice]
  end

  test 'login and browse site' do
    get login_path
    assert_response :success

    login
    #assert_equals root_path, path
    get profile_path
    assert_response :success
  end

  # Test events
  test 'not logged in and can submit event' do
    assert false
  end

  test 'logged in and can submit event' do
    login

    get new_event_path
    assert_response :success

    event = Event.first
    # doesn't work!
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

  # Test reports
  test 'not logged in cannot submit report' do
    post reports_path, report: {event_id: Event.first.id, description: 'Bad event!'}
    assert_equal 'You must be logged in to access this page.', flash[:alert]
  end

  test 'login and submit valid report' do
    login

    get new_report_path, id: Event.first.id
    assert_response :success

    post reports_path, report: {event_id: Event.first.id, description: 'Bad event!'} #:format => 'json', 'report[description]' => 'Crap!', 'report[event_id]' => 1
    assert_equal 'Report successfully submitted.', flash[:notice]
  end

  test 'login and submit invalid report' do
    login

    post_via_redirect reports_path, report: {event_id: Event.first.id, description: ''}
    assert_equal 'Unable to submit report.', flash[:notice]

    post_via_redirect reports_path, report: {event_id: 0, description: 'Yup!'}
    assert_equal 'Unable to submit report.', flash[:notice]
  end
end