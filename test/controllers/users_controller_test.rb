require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @newuser = users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should not get destroy" do
    post :destroy, id: @newuser.id
    assert_redirected_to login_path
  end

  test "should get create" do
    assert_difference('User.count') do
      post :create, user: { username: 'newuser2', password: '!password', password_confirmation: '!password',
                            email: 'newemail@school.com', first_name: @newuser.first_name, last_name: @newuser.last_name,
                            date_of_birth: @newuser.date_of_birth}
    end
    assert_redirected_to root_path
    assert_equal 'User successfully created.', flash[:notice]
  end

  test "should not get edit" do
    get :edit
    assert_redirected_to login_path
  end

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

  test 'email validation' do
    # Generate email validation token
    @newuser.set_email_validation

    # Use token and validate email
    get :validate_email, token: @newuser.email_validation_token
    assert_redirected_to root_path
    assert_equal 'Email was successfully validated.', flash[:notice]

    # Attempt to use same token again
    get :validate_email, token: @newuser.email_validation_token
    assert_redirected_to root_path
    assert_equal 'Validation link invalid.', flash[:notice]
  end

end
