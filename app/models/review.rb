class Review < ActiveRecord::Base
    belongs_to :user
    belongs_to :video

    validates :content, presence: true

    def self.latest_reviews
      order("created_at DESC")
    end
end