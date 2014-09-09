require 'spec_helper'

describe RelationshipsController do 
  describe "GET index" do
   it_behaves_like "requires sign in" do
    let(:action) {get :index}
   end
   it "sets @relationships to relationships, current user is following" do
     lilo = Fabricate(:user)
     set_current_user(lilo)
     nani = Fabricate(:user)
     relationship = Fabricate(:relationship, leader: nani, follower: lilo)
     get :index
     expect(assigns(:relationships)).to eq([relationship])
   end
  end

  describe "DELETE destroy" do
    it_behaves_like "requires sign in" do
      let(:action) {get :index, id: 4}
    end
    it "deletes relationship with leader" do
      lilo = Fabricate(:user)
      set_current_user(lilo)
      nani = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: nani, follower: lilo)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(0)
    end
    it "redirects to people page" do
      lilo = Fabricate(:user)
      set_current_user(lilo)
      nani = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: nani, follower: lilo)
      delete :destroy, id: relationship
      expect(response).to redirect_to people_path
    end 

    it "does not delete a relationship if current_user is not the follower" do
      lilo = Fabricate(:user)
      set_current_user(lilo)
      nani = Fabricate(:user)
      david = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: nani, follower: david)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(1)
    end

  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) {post :create, leader_id: 3}
    end
    it "redirect_to people page" do
     lilo = Fabricate(:user)
     set_current_user(lilo)
     nani = Fabricate(:user)
     post :create, leader_id: nani.id
     expect(response).to redirect_to people_path
    end
    it "creates relatioship between leader and follower" do
     lilo = Fabricate(:user)
     set_current_user(lilo)
     nani = Fabricate(:user)
     post :create, leader_id: nani.id
     expect(lilo.following_relationships.first.leader).to eq(nani)
    end
    it "does not create a relationship if it already exists" do
     lilo = Fabricate(:user)
     set_current_user(lilo)
     nani = Fabricate(:user)
     relationship = Fabricate(:relationship, leader: nani, follower: lilo)
     post :create, leader_id: nani.id
     expect(lilo.following_relationships.count).to eq(1)
    end
    it "does not allow one to follow themselves" do
      lilo = Fabricate(:user)
      set_current_user(lilo)
      post :create, leader_id: lilo.id
      expect(lilo.following_relationships.count).to eq(0)
    end
  end
end