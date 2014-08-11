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

  within(:xpath, "//tr[contains(.,'#{beckham.title}')]") do
    fill_in "queue_items[][position]", with: 3
  end

  within(:xpath, "//tr[contains(.,'#{snatch.title}')]") do
    fill_in "queue_items[][position]", with: 1
  end

  within(:xpath, "//tr[contains(.,'#{arthur.title}')]") do
    fill_in "queue_items[][position]", with: 2
  end

  click_button "Update Instant Queue"

  expect(find(:xpath, "//tr[contains(.,'#{beckham.title}')]//input[@type='text']").value).to eq("3")
  expect(find(:xpath, "//tr[contains(.,'#{snatch.title}')]//input[@type='text']").value).to eq("1")
  expect(find(:xpath, "//tr[contains(.,'#{arthur.title}')]//input[@type='text']").value).to eq("2")
  
  end  


end