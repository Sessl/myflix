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

    context "with valid personal info and valid card" do
      
      let(:charge) { double(:charge, successful?: true)}
      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end

      it "sets the @user variable" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(User.count).to eq(1)
      end

      it "displays flash[:notice] if @user is saved" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(flash[:notice]).to_not be_nil
      end

      it "saves @user.id to session[:user_id] if @user is saved" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(session[:user_id]).to eq(User.first.id)
      end

      it "makes the user follow the inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        post :create, user: { email: 'joe@example.com', password: "password", username: 'Joe Doe'}, invitation_token: invitation.token
        joe = User.where(email: 'joe@example.com').first
        expect(joe.follows?(alice)).to be_truthy
      end

      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        post :create, user: { email: 'joe@example.com', password: "password", username: 'Joe Doe'}, invitation_token: invitation.token
        joe = User.where(email: 'joe@example.com').first
        expect(alice.follows?(joe)).to be_truthy
      end
      
      it "expires the invitation upon acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        post :create, user: { email: 'joe@example.com', password: "password", username: 'Joe Doe'}, invitation_token: invitation.token
        expect(Invitation.first.token).to be_nil
      end

      it "redirects to home_path if @user is saved" do 
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to home_path
      end

    end
    
    context "valid personal info and declined card" do

      let(:charge) { double(:charge, successful?: false, error_message: "Your card was declined.")}
      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end

      it "does not create a new user record" do
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1231241'
        expect(User.count).to eq(0)
      end
      it "renders the new template" do
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1231241'
        expect(response).to render_template :new
      end
      it "sets the flash error message" do
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1231241'
        expect(flash[:danger]).to be_present
      end
      
    end

    context "with invalid personal info" do

      it "does not send out email with invalid inputs" do
        post :create, user: { email: "joe@example" }
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "render :new if @user is not saved" do
        post :create, user: {email: "joe@example.com", password: "somepassword"}
        expect(response).to render_template :new
      end

      it "does not charge the card" do
        StripeWrapper::Charge.should_not_receive(:create)
        post :create, user: { email: "kevin@example.com" }
      end

    end

    context "sending emails" do
      
      let(:charge) { double(:charge, successful?: true) }
      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end

      after { ActionMailer::Base.deliveries.clear }

      it "sends out email to the user with valid inputs" do
        post :create, user: { email: "joe@example.com", password: "password", password_confirmation: "password", username: "Joe Smith"}
        expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
      end

      it "sends out email containing the user's name with valid inputs" do
        post :create, user: { email: "joe@example.com", password: "password", password_confirmation: "password", username: "Joe Smith"}
        expect(ActionMailer::Base.deliveries.last.body).to include("Joe Smith")
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