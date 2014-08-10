require 'spec_helper'

feature "Signing in" do
  background do
    User.create(:email => "user@example.com", :username => "Annie", :password => "caplin")
  end
  scenario "Signing in with correct credentials" do
    visit sign_in_path
    fill_in "Email Address", :with => "user@example.com"
    fill_in "Password", :with => "caplin"
    click_button "Sign in"
    page.should have_content "Annie"
  end
end