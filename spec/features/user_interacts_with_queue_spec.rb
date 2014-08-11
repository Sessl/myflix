require 'spec_helper'

feature "User interacts with the queue" do
  scenario "user adds and reorders videos in the queue" do
  category = Fabricate(:category)
  beckham = Fabricate(:video)
  snatch = Fabricate(:video)
  arthur = Fabricate(:video)
  beckham.categories << category
  snatch.categories << category
  arthur.categories << category

  sign_in
  find("a[href='/videos/#{beckham.id}']").click
  page.should have_content(beckham.title)

  click_link "+ My Queue"
  page.should have_content(beckham.title)

  visit video_path(beckham)
  page.should_not have_content "+ My Queue"

  visit home_path
  find("a[href='/videos/#{snatch.id}']").click
  click_link "+ My Queue"

  visit home_path
  find("a[href='/videos/#{arthur.id}']").click
  click_link "+ My Queue"

  fill_in "video_#{beckham.id}", with: 3
  fill_in "video_#{snatch.id}", with: 1
  fill_in "video_#{arthur.id}", with: 2

  click_button "Update Instant Queue"
  expect(find("#video_#{beckham.id}").value).to eq("3")
  expect(find("#video_#{snatch.id}").value).to eq("1")
  expect(find("#video_#{arthur.id}").value).to eq("2")

  end  


end