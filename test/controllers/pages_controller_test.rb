require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get pages_login_url
    assert_response :success
  end

  test "should get index" do
    get pages_index_url
    assert_response :success
  end

  test "should get admin" do
    get pages_admin_url
    assert_response :success
  end

end
