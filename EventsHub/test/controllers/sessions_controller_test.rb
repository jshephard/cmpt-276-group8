require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get destroy" do
    get :destroy
    assert_response :success
  end

  test 'valid user and password can login' do
    get :new
    assert_response :success
    post :new, session: { username: users(:one).username, password: '!password', remember_me: false }
    assert_response :success
  end

end
