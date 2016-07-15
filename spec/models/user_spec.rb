require 'spec_helper'

describe User do
  it {should validate_presence_of(:username)}

  it {should validate_presence_of(:email)}

  it {should validate_presence_of(:password)}

  it {should have_many(:queue_items).order(:position)}

  it {should have_many(:reviews).order("created_at DESC")}

  it {should have_many(:following_relationships)}

  it {should have_many(:leading_relationships)}

  #removing test on line 20 since random token is only created when password reset is requested

  #it "generates a random token when the user is created" do
  #  alice = Fabricate(:user)
  #  expect(alice.token).to be_present
  #end

  describe "#queued_video?" do
    it "returns true when the user queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      user.queued_video?(video).should be_truthy 
    end
    it "returns false when the user has not queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      user.queued_video?(video).should be_falsey
    end
  end

  describe "#follows?" do
    it "returns true when the user has a following_relationship with another user" do
      lilo = Fabricate(:user)
      nani = Fabricate(:user)
      Fabricate(:relationship, leader: nani, follower: lilo)
      expect(lilo.follows?(nani)).to be_truthy
    end
    it "returns false when the user does not have a following_relationship with another user" do
      lilo = Fabricate(:user)
      nani = Fabricate(:user)
      Fabricate(:relationship, leader: lilo, follower: nani)
      expect(lilo.follows?(nani)).to be_falsey
    end
  end

  describe "follow" do
    it "follows another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      alice.follow(bob)
      expect(alice.follows?(bob)).to be_truthy
    end
    it "does not follow oneself" do
      alice = Fabricate(:user)
      alice.follow(alice)
      expect(alice.follows?(alice)).to be_falsey
    end
  end

  describe "deactivate!" do
    it "deactivates an active user" do
      alice = Fabricate(:user, active: true)
      alice.deactivate!
      expect(alice).not_to be_active
    end
  end
end