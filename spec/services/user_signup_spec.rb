require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
    context "valid personal info and valid card" do
      
      let(:customer) { double(:customer, successful?: true)}
      before do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
      end

      after { ActionMailer::Base.deliveries.clear }


      it "sets the @user variable" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.count).to eq(1)
      end
      it "makes the user follow the inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        UserSignup.new(Fabricate.build(:user, email: 'joe@example.com', password: "password", username: 'Joe Doe')).sign_up("some_stripe_token", invitation.token)
        joe = User.where(email: 'joe@example.com').first
        expect(joe.follows?(alice)).to be_truthy
      end
      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        UserSignup.new(Fabricate.build(:user, email: 'joe@example.com', password: "password", username: 'Joe Doe')).sign_up("some_stripe_token", invitation.token)
        joe = User.where(email: 'joe@example.com').first
        expect(alice.follows?(joe)).to be_truthy
      end
      it "expires the invitation upon acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        UserSignup.new(Fabricate.build(:user, email: 'joe@example.com', password: "password", username: 'Joe Doe')).sign_up("some_stripe_token", invitation.token)
        expect(Invitation.first.token).to be_nil
      end
      it "sends out email to the user with valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: 'joe@example.com')).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
      end
      it "sends out email containing the user's name with valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: 'joe@example.com', username: 'Joe Smith')).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.body).to include("Joe Smith")
      end 


    end

    context "valid personal info and declined card" do

      let(:customer) { double(:customer, successful?: false, error_message: "Your card was declined.")}
      before do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
      end

      it "does not create a new user record" do
        UserSignup.new(Fabricate.build(:user)).sign_up('1231241', nil)
        expect(User.count).to eq(0)
      end
      
    end

    context "with invalid personal info" do

      it "does not send out email with invalid inputs" do
        UserSignup.new(User.new(email: "johnsmith@example.com")).sign_up('1231241', nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "does not charge the card" do
        expect(StripeWrapper::Customer).not_to receive(:create)
        UserSignup.new(User.new(email: "johnsmith@example.com")).sign_up('1231241', nil)
      end

    end
  end
end