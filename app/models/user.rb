class User < ActiveRecord::Base

  validates :username, presence: true
  validates :email, presence: true
  validates :password, presence: true
  validates_confirmation_of :password
  has_secure_password validations: false
  has_many :reviews, -> { order "created_at DESC" }
  has_many :queue_items, -> { order :position }
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id
  
  RESET_TIME = 2.hours.ago
 
  def normalize_queue_item_positions
      queue_items.each_with_index do |queue_item, index|
        queue_item.update_attributes(position: index + 1)
      end
   end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def follows?(another_user)
    following_relationships.map(&:leader).include?(another_user)
  end
  
  def follow(another_user)
    following_relationships.create(leader: another_user) if can_follow?(another_user)
  end

  def can_follow?(another_user)
    !(self.follows?(another_user) || self == another_user)
  end
  
  def generate_password_reset_token
    update_column(:token, SecureRandom.urlsafe_base64)
    update_column(:token_set_time, Time.zone.now)
  end
end