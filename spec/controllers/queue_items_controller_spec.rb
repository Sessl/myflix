require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_times to the queue items of the logged in user" do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      queue_item1 = Fabricate(:queue_item, user: alice)
      queue_item2 = Fabricate(:queue_item, user: alice)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
    it "redirects to the sign in page for unauthenticated users" do
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end 

  describe "Post create" do
    it "redirect to the my_queue page" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end
    it "creates a queue item" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end
    it "creates the queue item that is associated with the video" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end
    it "creates the queue item that is associated with the current user" do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(alice)
    end
    it "add the video as the last item in the queue" do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      gameofthrones = Fabricate(:video)
      Fabricate(:queue_item, video: gameofthrones, user: alice)
      lilo = Fabricate(:video)
      post :create, video_id: lilo.id
      lilo_queue_item = QueueItem.where(video_id: lilo.id, user_id: alice.id).first
      expect(lilo_queue_item.position).to eq(2)
    end

    it "does not add the video to the queue if it already exists" do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      gameofthrones = Fabricate(:video)
      Fabricate(:queue_item, video: gameofthrones, user: alice)
      post :create, video_id: gameofthrones.id
      expect(QueueItem.count).to eq(1)
    end
    it "redirects to the sign in page if user is not signed in" do
      post :create, video_id: 3
      expect(response).to redirect_to sign_in_path
    end
  end
end