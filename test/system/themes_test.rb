require "application_system_test_case"

class ThemesTest < ApplicationSystemTestCase
  setup do
    @theme = themes(:one)
  end

  test "visiting the index" do
    visit themes_url
    assert_selector "h1", text: "Themes"
  end

  test "should create theme" do
    visit themes_url
    click_on "New theme"

    fill_in "Font", with: @theme.font
    fill_in "Heading", with: @theme.heading
    fill_in "Main background", with: @theme.main_background
    fill_in "Medication-main", with: @theme.medication-main
    fill_in "Medication background", with: @theme.medication_background
    fill_in "Schedule background", with: @theme.schedule_background
    click_on "Create Theme"

    assert_text "Theme was successfully created"
    click_on "Back"
  end

  test "should update Theme" do
    visit theme_url(@theme)
    click_on "Edit this theme", match: :first

    fill_in "Font", with: @theme.font
    fill_in "Heading", with: @theme.heading
    fill_in "Main background", with: @theme.main_background
    fill_in "Medication-main", with: @theme.medication-main
    fill_in "Medication background", with: @theme.medication_background
    fill_in "Schedule background", with: @theme.schedule_background
    click_on "Update Theme"

    assert_text "Theme was successfully updated"
    click_on "Back"
  end

  test "should destroy Theme" do
    visit theme_url(@theme)
    click_on "Destroy this theme", match: :first

    assert_text "Theme was successfully destroyed"
  end
end
