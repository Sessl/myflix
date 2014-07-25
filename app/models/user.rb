class User < ActiveRecord::Base
  validates :username, presence: true
  validates :email, presence: true
  validates :password, presence: true
  has_secure_password validations: false
  has_many :reviews
  has_many :queue_items, order: :position
  
  def normalize_queue_item_positions
      queue_items.each_with_index do |queue_item, index|
        queue_item.update_attributes(position: index + 1)
      end
   end

end