require 'spec_helper'

describe RelationshipsController do 
  describe "GET index" do
   it_behaves_like "requires sign in" do
    let(:action) {get :index}
   end
   it "sets @relationships to relationships of current user is following" do
     lilo = Fabricate(:user)
     set_current_user(lilo)
     nani = Fabricate(:user)
     relationship = Fabricate(:relationship, leader: nani, follower: lilo)
     get :index
     expect(assigns(:relationships)).to eq([relationship])
   end
  end

  describe "DELETE destroy" do
    it "deletes relationship with leader" do
      lilo = Fabricate(:user)
      set_current_user(lilo)
      nani = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: nani, follower:lilo)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(0)
    end
  end
end