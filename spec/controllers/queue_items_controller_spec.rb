require 'spec_helper'

describe QueueItemsController do

  before do
    set_current_user  #using macros from support/macros.rb
  end

  describe "GET index" do
    it "sets @queue_times to the queue items of the logged in user" do
      #alice = Fabricate(:user)
      #session[:user_id] = alice.id
      queue_item1 = Fabricate(:queue_item, user: current_user)
      queue_item2 = Fabricate(:queue_item, user: current_user)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
    it "redirects to the sign in page for unauthenticated users" do
      clear_current_user
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end 

  describe "Post create" do
    it "redirect to the my_queue page" do
    #  session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end
    it "creates a queue item" do
     # session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end
    it "creates the queue item that is associated with the video" do
     # session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end
    it "creates the queue item that is associated with the current user" do
    #  alice = Fabricate(:user)
     # session[:user_id] = alice.id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(current_user)
    end
    it "adds the video as the last item in the queue" do
    #  alice = Fabricate(:user)
    #  session[:user_id] = alice.id
      gameofthrones = Fabricate(:video)
      Fabricate(:queue_item, video: gameofthrones, user: current_user)
      lilo = Fabricate(:video)
      post :create, video_id: lilo.id
      lilo_queue_item = QueueItem.where(video_id: lilo.id, user_id: current_user.id).first
      expect(lilo_queue_item.position).to eq(2)
    end

    it "does not add the video to the queue if it already exists" do
     # alice = Fabricate(:user)
    #  session[:user_id] = alice.id
      gameofthrones = Fabricate(:video)
      Fabricate(:queue_item, video: gameofthrones, user: current_user)
      post :create, video_id: gameofthrones.id
      expect(QueueItem.count).to eq(1)
    end
    it "redirects to the sign in page if user is not signed in" do
      clear_current_user
      post :create, video_id: 3
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "DELETE destroy" do
    it "should redirect to my_queue page" do
    #  session[:user_id] = Fabricate(:user).id
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end
    it "deletes the queue item" do
    #  alice = Fabricate(:user)
    #  session[:user_id] = alice.id
      queue_item = Fabricate(:queue_item, user: current_user)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end
    it "normalizes queue items after deletion" do
    #  alice = Fabricate(:user)
    #  session[:user_id] = alice.id
      queue_item1 = Fabricate(:queue_item, user: current_user, position: 1)
      queue_item2 = Fabricate(:queue_item, user: current_user, position: 2)
      queue_item3 = Fabricate(:queue_item, user: current_user, position: 3)
      delete :destroy, id: queue_item2.id
      expect(current_user.queue_items.map(&:position)).to eq([1,2])
    end
    it "does not delete the queue item if it is not in the current user's queue" do
     # alice = Fabricate(:user)
     # session[:user_id] = alice.id
      james = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: james)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end
    it "redirects unauthenticated users to signin page" do
      clear_current_user
      delete :destroy, id: 3
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST update_queue" do
    context "with valid inputs" do
    #  let(:alice) {Fabricate(:user)}
      let(:video) {Fabricate(:video)}
      let(:queue_item1) {Fabricate(:queue_item, user: current_user, position: 1, video: video)}
      let(:queue_item2) {Fabricate(:queue_item, user: current_user, position: 2, video: video)}
    #  before do
    #    session[:user_id] = alice.id
    #  end
      it "redirects to the my_queue page" do
        
        post :update_queue, queue_items: [{id: queue_item1, position: 2},{id: queue_item2, position: 1}]
        expect(response).to redirect_to my_queue_path
      end
      it "reorders the queue items" do
        
        post :update_queue, queue_items: [{id: queue_item1, position: 2},{id: queue_item2, position: 1}]
        expect(current_user.queue_items).to eq([queue_item2, queue_item1])
      end

      it "normalizes the position numbers" do
        
        post :update_queue, queue_items: [{id: queue_item1, position: 3},{id: queue_item2, position: 2}]
        expect(current_user.queue_items.map(&:position)).to eq([1,2])
       #require 'pry'; binding.pry
       #line 122 and lines 124-125 will give the same result provided reload method is used on queue_item1 & queue_item2
       #expect(queue_item1.reload.position).to eq(2)
       #expect(queue_item2.reload.position).to eq(1)
      end

    end
    context "with invalid inputs" do
     # let(:alice) {Fabricate(:user)}
      let(:video) {Fabricate(:video)}
      let(:queue_item1) {Fabricate(:queue_item, user: current_user, position: 1, video: video)}
      let(:queue_item2) {Fabricate(:queue_item, user: current_user, position: 2, video: video)}
    #  before do
    #    session[:user_id] = alice.id
    #  end
      it "redirects to the my queue page" do
        
        post :update_queue, queue_items: [{id: queue_item1, position: 3.5},{id: queue_item2, position: 2}]
        expect(response).to redirect_to my_queue_path

        #this test passes because in the controller following the update_queue method we have the redirect.

      end
      it "sets the flash error message" do
        
        post :update_queue, queue_items: [{id: queue_item1, position: 3.5},{id: queue_item2, position: 2}]
        expect(flash[:error]).to be_present
      end
      it "does not change the order of queue items" do
        
        #now we make queue_item1 position valid and queue_item2 position invalid and when we run it, the first-time round following test should fail because queue_item1 position would change and queue_item2 position would not.
        #to get the test to past we implement a transaction in the controller action so that even one fails the other changes are also rolled back.
        post :update_queue, queue_items: [{id: queue_item1, position: 3},{id: queue_item2, position: 1.5}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
    context "with unauthenticated users" do
      it "redirects to sign_in_path" do
        clear_current_user
        post :update_queue, queue_items: [{id: 1, position: 3},{id: 2, position: 1}]
        expect(response).to redirect_to sign_in_path
      end
    end
    context "with queue items that do not belong to the current user" do
      it "should not change queue items" do
      #  alice = Fabricate(:user)
        alan = Fabricate(:user)
      #  session[:user_id] = alan.id
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: alan, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: current_user, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1, position: 3},{id: queue_item2, position: 1}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end
end