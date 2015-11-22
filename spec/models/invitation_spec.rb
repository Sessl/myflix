require 'spec_helper'

describe Invitation do
  it { should validate_presence_of(:recipient_name)}
  it { should validate_presence_of(:recipient_email)}
  it { should validate_presence_of(:message)}

  it "generates a random token when the invitation is created" do
  	invitation = Fabricate(:invitation)
  	expect(invitation.token).to be_present
  end
end