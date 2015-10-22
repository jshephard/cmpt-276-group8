require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
  test 'login and browse site' do
    get login_path
    assert_response :success

    post_via_redirect login_path, session: { username: users(:one).username, password: '!password', remember_me: false }
    assert_response :success
    #assert_equals root_path, path
    get profile_path
    assert_response :success
  end
end