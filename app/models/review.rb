class Review < ActiveRecord::Base
    belongs_to :user
    belongs_to :video, touch: true

 #   validates :content, presence: true
 # instead of line 5 now using line 7 for multiple validations
    validates_presence_of :content, :rating

    def self.latest_reviews
      order("created_at DESC")
    end
end