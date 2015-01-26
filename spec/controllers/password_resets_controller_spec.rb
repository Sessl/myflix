require 'spec_helper'

describe PasswordResetsController, type: :controller do
  describe "GET show" do
    it "renders show template if the token is valid" do
      alice = Fabricate(:user)
      alice.update_column(:token, '12345')
      alice.update_column(:token_set_time, Time.zone.now)
      get :show, id: '12345'
      expect(response).to render_template :show
    end

    it "sets @token" do
      alice = Fabricate(:user)
      alice.update_column(:token, '12345')
      alice.update_column(:token_set_time, Time.zone.now)
      get :show, id: '12345'
      expect(assigns(:token)).to eq('12345')
    end

    it "redirects to expired token page if token_set_time is over 2 hours ago" do
      alice = Fabricate(:user)
      alice.update_column(:token, '12345')
      alice.update_column(:token_set_time, 3.hours.ago)
      get :show, id: '12345'
      expect(response).to redirect_to expired_token_path
    end

    it "redirects to the expired token page if the token is not valid" do
      get :show, id: '12345'
      expect(response).to redirect_to expired_token_path
    end
  end
  describe "POST create" do
    context "with valid token" do
      it "redirects to the sign in page" do
        alice = Fabricate(:user, password: 'old_password')
        alice.update_column(:token, '12345')
        alice.update_column(:token_set_time, Time.zone.now)
        post :create, token: '12345', password: 'new_password', password_confirmation: 'new_password'
        expect(response).to redirect_to sign_in_path
      end
      it "updates the user's password" do
        alice = Fabricate(:user, password: 'old_password')
        alice.update_column(:token, '12345')
        alice.update_column(:token_set_time, Time.zone.now)
        post :create, token: '12345', password: 'new_password', password_confirmation: 'new_password'
        expect(alice.reload.authenticate('new_password')).to be_truthy
      end
      
      it "sets the flash success message" do
        alice = Fabricate(:user, password: 'old_password')
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password', password_confirmation: 'new_password'
        expect(flash[:success]).to be_present
      end
      it "sets user token to nil" do
        alice = Fabricate(:user, password: 'old_password')
        alice.update_column(:token, '12345')
        alice.update_column(:token_set_time, Time.zone.now)
        post :create, token: '12345', password: 'new_password', password_confirmation: 'new_password'
        expect(alice.reload.token).not_to eq('12345')
      end
    end

    context "with valid token but password mismatch" do
      it " sets flash error mismatch message" do
        alice = Fabricate(:user, password: 'old_password')
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password', password_confirmation: 'mistmatch'
        expect(flash[:error]).to be_present
      end
      it "renders show template" do
        alice = Fabricate(:user, password: 'old_password')
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password', password_confirmation: 'mistmatch'
        expect(response).to redirect_to password_reset_path('12345')
      end
    end

    context "with invalid token" do
      it "redirects to the expired token path" do
        post :create, token: '12345', password: 'some_password', password_confirmation: 'some_password'
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end