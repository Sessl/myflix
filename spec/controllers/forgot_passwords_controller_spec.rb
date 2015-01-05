require 'spec_helper'

describe ForgotPasswordsController, type: :controller do 
  describe "POST create" do
    context "with blank input" do
      it "redirects to the forgot password page" do
        post :create, email: ''
        expect(response).to redirect_to forgot_password_path
      end
      it "shows an error message" do
        post :create, email: ''
        expect(flash[:error]).to eq("Email cannot be blank.")
      end
    end
    context "with existing email" do
      it "redirects to the confirm page" do
        Fabricate(:user, email: "joe@example.com")
        post :create, email: "joe@example.com"
        expect(response).to redirect_to forgot_password_confirmation_path
      end
      it "sends out an email to the email address" do
        Fabricate(:user, email: "joe@example.com")
        post :create, eamil: "joe@example.com"
        expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
      end
    end
    context "with non-existent email" do
      it "redirects to the forgot passowrd page" do
        post :create, email: "foo@example.com"
        expect(response).to redirect_to forgot_password_path
      end
      it "shows an error message" do
        post :create, email: "foo@example.com"
        expect(flash[:error]).to eq("There is no user with that email in the system.")
      end
    end
  end 
    
end