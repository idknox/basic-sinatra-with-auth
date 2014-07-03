require 'spec_helper'

feature "Delete User" do
  scenario "deleting a user removes user from list" do
    visit "/"

    click_button "Register"

    fill_in "name", :with => "Ashley"
    fill_in "password", :with => "password"
    click_button "Submit"

    expect(page).to have_content("Thank you for registering")

    visit "/"

    click_button "Register"

      fill_in "name", :with => "Ian"
      fill_in "password", :with => "password"
      click_button "Submit"

      expect(page).to have_content("Thank you for registering")
      fill_in "username", :with => "Ian"
      fill_in "password", :with => "password"

      click_button "Submit"

      expect(page).to have_content("Welcome, Ian")

      click_button "Delete"

      expect(page).to have_content("You deleted Ashley")

  end
end