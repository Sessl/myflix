class Review < ActiveRecord::Base
    belongs_to :user
    belongs_to :video

  def latest_reviews
    order("created_at DESC")
  end
end