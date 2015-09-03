class Invitation < ActiveRecord::Base
  belongs_to :inviter, class_name: "User"

  validates_presence_of :recipient_name, :recipient_email, :message
  
  before_create :generate_invitation_token

  def generate_invitation_token
    self.token = SecureRandom.urlsafe_base64
  end

end