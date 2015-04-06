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
  go_to_video_page(beckham)
  expect_page_to_show_title(beckham)        #testing show video page

  click_link_to_enqueue("+ My Queue")
  expect_page_to_show_title(beckham)

  visit video_path(beckham)
  expect_link_not_to_be_seen("+ My Queue")
  
  add_video_to_queue(snatch)
  add_video_to_queue(arthur)

  set_video_position(beckham, 3)
  set_video_position(snatch, 1)
  set_video_position(arthur, 2)

  update_queue

  expect_video_position(beckham, 3)
  expect_video_position(snatch, 1)
  expect_video_position(arthur, 2)

  end 
  

  def go_to_video_page(video)
    find("a[href='/videos/#{video.id}']").click
  end

  def expect_page_to_show_title(video)
    page.should have_content(video.title)
  end

  def click_link_to_enqueue(button_text)
    click_link button_text
  end

  def expect_link_not_to_be_seen(link_text)
    page.should_not have_content(link_text) 
  end

  def update_queue
    click_button "Update Instant Queue"
  end

  def add_video_to_queue(video)
    visit home_path
    click_on_video_on_home_page(video)
    click_link "+ My Queue"
  end

  def set_video_position(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do
    fill_in "queue_items[][position]", with: position
  end
  end
 
  def expect_video_position(video, position)
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(position.to_s)
  end

end