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

  find("input[data-video-id='#{beckham.id}']").set(3)
  find("input[data-video-id='#{snatch.id}']").set(1)
  find("input[data-video-id='#{arthur.id}']").set(2)
 
  click_button "Update Instant Queue"
  expect(find("input[data-video-id='#{beckham.id}']").value).to eq("3")
  expect(find("input[data-video-id='#{snatch.id}']").value).to eq("1")
  expect(find("input[data-video-id='#{arthur.id}']").value).to eq("2")

  end  


end