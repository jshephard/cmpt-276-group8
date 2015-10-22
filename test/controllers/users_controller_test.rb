require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
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

end
