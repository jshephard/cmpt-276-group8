require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
  test 'login and browse site' do
    get '/login'
    assert_response :success

    post_via_redirect '/login', username: users(:one).username, password: '!password'
    assert_response :success
  end
end