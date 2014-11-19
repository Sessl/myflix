require 'spec_helper'


describe UsersController, type: :controller do

  describe "GET new" do
    it "sets the @user variable to a new instance of class User" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end

    it "redirects to home_path if current_user exists" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
    it " renders :new if current_user does not exist" do
      get :new
      expect(response).to render_template :new
    end

  end

  describe "POST create" do
    it "sets the @user variable" do
      post :create, user: Fabricate.attributes_for(:user)
      expect(User.count).to eq(1)
    end

    it "displays flash[:notice] if @user is saved" do
      post :create, user: Fabricate.attributes_for(:user)
      expect(flash[:notice]).to_not be_nil
    end

    it "saves @user.id to session[:user_id] if @user is saved" do
      #post :create, user: {username: "Bob Builder", email: "bob_b@bobb.com", password: "secret"}
      post :create, user: Fabricate.attributes_for(:user)
      expect(session[:user_id]).to eq(User.first.id)
    end

    it "redirects to home_path if @user is saved" do 
      post :create, user: Fabricate.attributes_for(:user)
      expect(response).to redirect_to home_path
    end
    it "render :new if @user is not saved" do
      post :create, user: {email: "gggggg@ggg.com", password: "ekekekekek"}
      expect(response).to render_template :new
    end

#    context "sending emails" do
#      it "sends out email to the user with valid inputs" do
#        post :create, user: { email: "joe@example.com", password: "password", username: "Joe Smith"}
#       expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
#      end
#      it "sends out email containing the user's name with valid inputs"
#    end

  end

  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 3}
    end
    it "gets the user with id from database and sets it to @user variable" do
      set_current_user
      alice = Fabricate(:user)
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end
  end

end