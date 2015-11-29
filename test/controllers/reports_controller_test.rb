require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  setup do
    @report = reports(:one)
  end

  test "should not get index" do
    get :index
    assert_redirected_to login_path
  end

  test "should not get new" do
    get :new
    assert_redirected_to login_path
  end

  test "should not get create" do
    get :create
    assert_redirected_to login_path
  end

  test "should not get destroy" do
    post :destroy, id: @report.id
    assert_redirected_to login_path
  end

end
