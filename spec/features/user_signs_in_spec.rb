require 'spec_helper'

feature "Signing in" do
  scenario "Signing in with correct credentials" do
    alice = Fabricate(:user)
    sign_in(alice)
    expect(page).to have_content(alice.username)
  end

  scenario "deactivated user" do
    alice = Fabricate(:user, active: false)
    sign_in(alice)
    expect(page).not_to have_content(alice.username)
    expect(page).to have_content("Your account has been suspended, please contact customer service")
  end
end