class Invitation < ActiveRecord::Base
  include Tokenable

  belongs_to :inviter, class_name: "User"

  validates_presence_of :recipient_name, :recipient_email, :message
  
#  before_create :generate_invitation_token

#  def generate_token
#  	self.token = SecureRandom.urlsafe_base64
#    self.token_set_time = Time.zone.now
# end
end