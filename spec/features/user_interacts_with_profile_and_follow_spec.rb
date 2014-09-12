require 'spec_helper'

feature "User interacts with reviewer profile and people I follow page" do
  scenario "user visits a reviewer profile page" do
    category = Fabricate(:category)
    beckham = Fabricate(:video)
    currentuser = Fabricate(:user)
    reviewer = Fabricate(:user)
    beckham.categories << category
    Fabricate(:review, user: reviewer, video: beckham)

    sign_in(currentuser)
    click_on_video_on_home_page(beckham)
    click_link_to_profile(reviewer.username)
    expect_page_to_show_name(reviewer)
    click_link_to_follow("Follow")
    expect_page_to_show_title("People I Follow")
    expect_page_to_show_name(reviewer)
    click_link_to_unfollow(reviewer,currentuser)
    expect_page_to_not_show(reviewer)

  end
    
    def click_link_to_profile(link_text)
      click_link link_text
    end

    def expect_page_to_show_name(leader)
      page.should have_content(leader.username)
    end

    def click_link_to_follow(button_text)
      click_link button_text
    end

    def expect_page_to_show_title(title)
      page.should have_content(title)
    end


    def click_link_to_unfollow(leader,follower)
      within(:xpath, "//tr[contains(.,'#{leader.username}')]") do
       find("a[href='/relationships/#{follower.following_relationships.first.id}']").click
      end
    end

    def expect_page_to_not_show(leader)
      page.should_not have_content(leader.username)
    end

end