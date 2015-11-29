require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get create" do
    @user = users(:one)
    post :create, session: { username: @user.username, password: '!password', remember_me: false }
    assert_redirected_to root_path
  end

  test "should not get destroy" do
    post :destroy
    assert_redirected_to login_path
  end

end
