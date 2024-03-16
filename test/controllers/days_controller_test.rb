require "test_helper"

class DaysControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get days_index_url
    assert_response :success
  end
end
