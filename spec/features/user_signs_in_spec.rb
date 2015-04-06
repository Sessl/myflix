require 'spec_helper'

feature "Signing in" do
  scenario "Signing in with correct credentials" do
    alice = Fabricate(:user)
    sign_in(alice)
    expect(page).to have_content(alice.username)
  end
end