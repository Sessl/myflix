require 'spec_helper'

feature "Signing in" do
  scenario "Signing in with correct credentials" do
    alice = Fabricate(:user)
    visit sign_in_path
    fill_in "Email Address", :with => alice.email
    fill_in "Password", :with => alice.password
    click_button "Sign in"
    page.should have_content alice.username
  end
end