require 'spec_helper'


describe UsersController do

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

    context "successful user sign up" do
      
      it "displays flash[:notice] if @user is saved" do
        result = double(:sign_up_result, successful?: true)
        expect_any_instance_of(UserSignup).to (:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(flash[:notice]).to_not be_nil
      end

      #it "saves @user.id to session[:user_id] if @user is saved" do
      #  charge = double(:charge, successful?: true)
      #  StripeWrapper::Charge.should_receive(:create).and_return(charge)
      #  post :create, user: Fabricate.attributes_for(:user)
      #  expect(session[:user_id]).to eq(User.first.id)
      #end


      it "saves @user.id to session[:user_id] if @user is saved" do
        result = double(:sign_up_result, successful?: true)
        expect_any_instance_of(UserSignup).to (:sign_up).and_return(result)
        alice = Fabricate(:user)
        user_result = User.stub_chain(:find, :first).and_return(alice.id)
        post :create, user: { email: alice.email, password: alice.password, password_confirmation: alice.password, username: alice.username }
        expect(session[:user_id]).to eq(user_result)
      end

      it "redirects to home_path if @user is saved" do 
        result = double(:sign_up_result, successful?: true)
        expect_any_instance_of(UserSignup).to (:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to home_path
      end

    end

    context "failed user sign up" do

      it "renders the new template" do
        result = double(:sign_up_result, successful?: false, error_message: "This is an error message")
        expect_any_instance_of(UserSignup).to (:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1231241'
        expect(response).to render_template :new
      end
      
      it "sets the flash error message" do
        result = double(:sign_up_result, successful?: false, error_message: "This is an error message")
        expect_any_instance_of(UserSignup).to (:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1231241'
        expect(flash[:danger]).to be_present
      end
      
    end

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

  describe "GET new_with_invitation_token" do
    
    it "renders the :new view template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "sets @user with recipient's email" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it "sets @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it "redirects to expired token page for invalid tokens" do
      get :new_with_invitation_token, token: 'asfdasd'
      expect(response).to redirect_to expired_token_path
    end
    
  end

end