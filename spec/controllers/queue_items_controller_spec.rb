require 'spec_helper'

describe QueueItemsController do

  describe "GET index" do
    it "sets @queue_times to the queue items of the logged in user" do
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_item1 = Fabricate(:queue_item, user: current_user)
      queue_item2 = Fabricate(:queue_item, user: current_user)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
    
    it_behaves_like "requires sign in" do
      let(:action) {get :index}
    end
  end 

  describe "Post create" do
    it "redirect to the my_queue page" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end
    it "creates a queue item" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end
    it "creates the queue item that is associated with the video" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end
    it "creates the queue item that is associated with the current user" do
      alice = Fabricate(:user)
      set_current_user(alice)
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(current_user)
    end
    it "adds the video as the last item in the queue" do
      alice = Fabricate(:user)
      set_current_user(alice)
      gameofthrones = Fabricate(:video)
      Fabricate(:queue_item, video: gameofthrones, user: current_user)
      lilo = Fabricate(:video)
      post :create, video_id: lilo.id
      lilo_queue_item = QueueItem.where(video_id: lilo.id, user_id: current_user.id).first
      expect(lilo_queue_item.position).to eq(2)
    end

    it "does not add the video to the queue if it already exists" do
      alice = Fabricate(:user)
      set_current_user(alice)
      gameofthrones = Fabricate(:video)
      Fabricate(:queue_item, video: gameofthrones, user: current_user)
      post :create, video_id: gameofthrones.id
      expect(QueueItem.count).to eq(1)
    end
    
    it_behaves_like "requires sign in" do
      let(:action) {post :create, video_id: 3}
    end

  end

  describe "DELETE destroy" do
    it "should redirect to my_queue page" do
      set_current_user
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end
    it "deletes the queue item" do
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_item = Fabricate(:queue_item, user: current_user)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end
    it "normalizes queue items after deletion" do
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_item1 = Fabricate(:queue_item, user: current_user, position: 1)
      queue_item2 = Fabricate(:queue_item, user: current_user, position: 2)
      queue_item3 = Fabricate(:queue_item, user: current_user, position: 3)
      delete :destroy, id: queue_item2.id
      expect(current_user.queue_items.map(&:position)).to eq([1,2])
    end
    it "does not delete the queue item if it is not in the current user's queue" do
      alice = Fabricate(:user)
      set_current_user(alice)
      james = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: james)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end 
    it_behaves_like "requires sign in" do
      let(:action) {delete :destroy, id: 3}
    end
  end

  describe "POST update_queue" do

    context "with unauthenticated users" do
      it_behaves_like "requires sign in" do
        let(:action) do
          post :update_queue, queue_items: [{id: 1, position: 3},{id: 2, position: 1}]
        end
      end
    end

    context "with valid inputs" do
      let(:alice) {Fabricate(:user)}
      let(:video) {Fabricate(:video)}
      let(:queue_item1) {Fabricate(:queue_item, user: current_user, position: 1, video: video)}
      let(:queue_item2) {Fabricate(:queue_item, user: current_user, position: 2, video: video)}

      before do
        set_current_user(alice)
      end

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
      end

    end
    context "with invalid inputs" do
      let(:alice) {Fabricate(:user)}
      let(:video) {Fabricate(:video)}
      let(:queue_item1) {Fabricate(:queue_item, user: current_user, position: 1, video: video)}
      let(:queue_item2) {Fabricate(:queue_item, user: current_user, position: 2, video: video)}

      before do
        set_current_user(alice)
      end
    
      it "redirects to the my queue page" do
        post :update_queue, queue_items: [{id: queue_item1, position: 3.5},{id: queue_item2, position: 2}]
        expect(response).to redirect_to my_queue_path

      end
      it "sets the flash error message" do
        post :update_queue, queue_items: [{id: queue_item1, position: 3.5},{id: queue_item2, position: 2}]
        expect(flash[:error]).to be_present
      end
      it "does not change the order of queue items" do
        post :update_queue, queue_items: [{id: queue_item1, position: 3},{id: queue_item2, position: 1.5}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

    context "with queue items that do not belong to the current user" do
      it "should not change queue items" do
        alice = Fabricate(:user)
        set_current_user(alice)
        alan = Fabricate(:user)
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: alan, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: current_user, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1, position: 3},{id: queue_item2, position: 1}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end
end