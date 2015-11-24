require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_redirected_to login_path
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get destroy" do
    get :destroy
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should not get edit" do
    get :edit
    assert_response '302'
  end

  #todo: create?
  #todo: update
  #todo: destroy

  test 'password validation token times out' do
    @user = User.first
    @user.set_password_validation
    @user.update_attribute(:password_validation_timeout, 1.days.ago)

    get :forgot_password
    assert_response :success

    # Should fail, validation has timed out
    post :forgot_password, {:format => 'json', token: @user.password_validation_token}
    assert_response 422

    @user.update_attribute(:password_validation_timeout, 1.days.from_now)

    # Should pass, validation times out one day from now
    post :forgot_password, {:format => 'json', token: @user.password_validation_token}
    assert_response 200

    # Should fail, password has been reset
    post :forgot_password, {:format => 'json', token: @user.password_validation_token}
    assert_response 422
  end

end
