class User < ActiveRecord::Base
  validates :username, presence: true
  validates :email, presence: true
  validates :password, presence: true
  has_secure_password validations: false
  has_many :reviews
  has_many :queue_items, order: :position
end