require 'spec_helper'

describe SessionsController do

  describe "GET new" do
    it "renders the sign_in form" do
      get :new
      expect(response).to render_template :new
    end
    it "redirects to home_path if current_user exsists" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    

    it "finds user by email" do
     penny = Fabricate(:user)
     post :create, email: penny.email, password: penny.password
      
      expect(assigns(:user)).to eq(penny)
    end
    it "saves user.id to session[:user_id] if user is authenticated" do
     penny = Fabricate(:user)
     post :create, email: penny.email, password: penny.password
      
      expect(session[:user_id]).to eq(penny.id)
    end
    it "displays flash[:notice] if user is authenticated" do
     penny = Fabricate(:user)
     post :create, email: penny.email, password: penny.password
      
      expect(flash[:notice]).to_not be_nil
    end
    it "redirects to home_path if user is authenticated" do
     penny = Fabricate(:user)
     post :create, email: penny.email, password: penny.password
      
      expect(response).to redirect_to home_path
    end
  

    it "displays flash danger if authentication fails" do
      penny = Fabricate(:user)
      post :create, email: penny.email, password:"wrongpassword"
      expect(flash[:danger]).to_not be_nil
    end
    it "redirects to sign_in_path if authentication fails" do
      penny = Fabricate(:user)
      post :create, email: penny.email, password:"wrongpassword"
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "GET destroy" do
    it "should set session[:user_id] to nil" do
      session[:user_id] = Fabricate(:user).id
      get :destroy 
      expect(session[:user_id]).to be_nil
    end
    it "should display notice indicating session ended" do
      session[:user_id] = Fabricate(:user).id
      get :destroy
      expect(flash[:notice]).to_not be_nil
    end
    it "should redirect_to root_path" do
      session[:user_id] = Fabricate(:user).id
      get :destroy
      expect(response).to redirect_to root_path
    end
  end
end