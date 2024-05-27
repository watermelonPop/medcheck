require "application_system_test_case"

class MedicationsTest < ApplicationSystemTestCase
  setup do
    @medication = medications(:one)
  end

  test "visiting the index" do
    visit medications_url
    assert_selector "h1", text: "Medications"
  end

  test "should create medication" do
    visit medications_url
    click_on "New medication"

    fill_in "Amount left", with: @medication.amount_left
    fill_in "Amount taken", with: @medication.amount_taken
    fill_in "Color", with: @medication.color
    fill_in "Dose amount", with: @medication.dose_amount
    fill_in "Dose unit", with: @medication.dose_unit
    fill_in "Icon", with: @medication.icon
    fill_in "Last picked up", with: @medication.last_picked_up
    fill_in "Name", with: @medication.name
    click_on "Create Medication"

    assert_text "Medication was successfully created"
    click_on "Back"
  end

  test "should update Medication" do
    visit medication_url(@medication)
    click_on "Edit this medication", match: :first

    fill_in "Amount left", with: @medication.amount_left
    fill_in "Amount taken", with: @medication.amount_taken
    fill_in "Color", with: @medication.color
    fill_in "Dose amount", with: @medication.dose_amount
    fill_in "Dose unit", with: @medication.dose_unit
    fill_in "Icon", with: @medication.icon
    fill_in "Last picked up", with: @medication.last_picked_up
    fill_in "Name", with: @medication.name
    click_on "Update Medication"

    assert_text "Medication was successfully updated"
    click_on "Back"
  end

  test "should destroy Medication" do
    visit medication_url(@medication)
    click_on "Destroy this medication", match: :first

    assert_text "Medication was successfully destroyed"
  end
end
