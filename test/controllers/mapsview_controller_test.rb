require 'test_helper'

class MapsviewControllerTest < ActionController::TestCase
  # Nothing to test in this controller
  # Simply is a view.
  test 'view map' do
    get :new
    assert_response :success
  end
end
