require "application_system_test_case"

class MedicationSchedulesTest < ApplicationSystemTestCase
  setup do
    @medication_schedule = medication_schedules(:one)
  end

  test "visiting the index" do
    visit medication_schedules_url
    assert_selector "h1", text: "Medication schedules"
  end

  test "should create medication schedule" do
    visit medication_schedules_url
    click_on "New medication schedule"

    fill_in "Day of week", with: @medication_schedule.day_of_week
    check "Taken" if @medication_schedule.taken
    fill_in "Time", with: @medication_schedule.time
    click_on "Create Medication schedule"

    assert_text "Medication schedule was successfully created"
    click_on "Back"
  end

  test "should update Medication schedule" do
    visit medication_schedule_url(@medication_schedule)
    click_on "Edit this medication schedule", match: :first

    fill_in "Day of week", with: @medication_schedule.day_of_week
    check "Taken" if @medication_schedule.taken
    fill_in "Time", with: @medication_schedule.time
    click_on "Update Medication schedule"

    assert_text "Medication schedule was successfully updated"
    click_on "Back"
  end

  test "should destroy Medication schedule" do
    visit medication_schedule_url(@medication_schedule)
    click_on "Destroy this medication schedule", match: :first

    assert_text "Medication schedule was successfully destroyed"
  end
end
