require "test_helper"

class DayTakensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @day_taken = day_takens(:one)
  end

  test "should get index" do
    get day_takens_url
    assert_response :success
  end

  test "should get new" do
    get new_day_taken_url
    assert_response :success
  end

  test "should create day_taken" do
    assert_difference("DayTaken.count") do
      post day_takens_url, params: { day_taken: { date: @day_taken.date, taken: @day_taken.taken } }
    end

    assert_redirected_to day_taken_url(DayTaken.last)
  end

  test "should show day_taken" do
    get day_taken_url(@day_taken)
    assert_response :success
  end

  test "should get edit" do
    get edit_day_taken_url(@day_taken)
    assert_response :success
  end

  test "should update day_taken" do
    patch day_taken_url(@day_taken), params: { day_taken: { date: @day_taken.date, taken: @day_taken.taken } }
    assert_redirected_to day_taken_url(@day_taken)
  end

  test "should destroy day_taken" do
    assert_difference("DayTaken.count", -1) do
      delete day_taken_url(@day_taken)
    end

    assert_redirected_to day_takens_url
  end
end
