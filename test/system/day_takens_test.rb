require "application_system_test_case"

class DayTakensTest < ApplicationSystemTestCase
  setup do
    @day_taken = day_takens(:one)
  end

  test "visiting the index" do
    visit day_takens_url
    assert_selector "h1", text: "Day takens"
  end

  test "should create day taken" do
    visit day_takens_url
    click_on "New day taken"

    fill_in "Date", with: @day_taken.date
    check "Taken" if @day_taken.taken
    click_on "Create Day taken"

    assert_text "Day taken was successfully created"
    click_on "Back"
  end

  test "should update Day taken" do
    visit day_taken_url(@day_taken)
    click_on "Edit this day taken", match: :first

    fill_in "Date", with: @day_taken.date
    check "Taken" if @day_taken.taken
    click_on "Update Day taken"

    assert_text "Day taken was successfully updated"
    click_on "Back"
  end

  test "should destroy Day taken" do
    visit day_taken_url(@day_taken)
    click_on "Destroy this day taken", match: :first

    assert_text "Day taken was successfully destroyed"
  end
end
