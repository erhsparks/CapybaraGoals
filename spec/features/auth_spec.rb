require 'spec_helper'
require 'rails_helper'

feature "the signup process" do
  let(:username) { "Capybara" }
  let(:password) { "CapybarasRule" }

  scenario "has a new user page" do
    visit new_user_url

    expect(page).to have_content "Create your Account:"
  end

  feature "signing up a user" do
    before(:each) do
      visit new_user_url
      fill_in "username", with: username
      fill_in "password", with: password

      click_on "Sign Up!"
    end

    scenario "redirects to user show page after signup" do
      expect(page).to have_content "Welcome"
    end

    scenario "shows username on the homepage after signup" do
      expect(page).to have_content username
    end
  end
end


feature "logging in" do
  let(:username) { "Capybara" }
  let(:password) { "CapybarasRule" }
  before(:each) { User.create(username: username, password: password) }

  scenario "has a login page" do
    visit new_session_url

    expect(page).to have_content "Log in:"
  end

  scenario "shows username on the homepage after login" do
    visit new_session_url
    fill_in "username", with: username
    fill_in "password", with: password

    click_on "Sign In!"

    expect(page).to have_content username
  end
end


feature "logging out" do
  let(:username) { "Capybara" }
  let(:password) { "CapybarasRule" }

  scenario "begins with a logged out state" do
    visit root_url

    expect(page).to_not have_content(username)
  end

  scenario "doesn't show username on the homepage after logout" do
    visit root_url

    click_on "sign up"
    fill_in "username", with: username
    fill_in "password", with: password
    click_on "Sign Up!"
    click_on "sign out"

    expect(page).to_not have_content(username)
  end

end
