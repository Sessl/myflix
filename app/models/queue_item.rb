class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video


  delegate :title, to: :video, prefix: :video

  validates_numericality_of :position, {only_integer: true}
  
  def rating
  #	review = Review.where(user_id: user.id, video_id: video.id).first refactoring with private review method which also uses memoization.
  	review.rating if review
  end

  def rating=(new_rating)  #this is a active record virtual attributte so that we can pass the rating update to Review
    # review = Review.where(user_id: user.id, video_id: video.id).first using review private method
    # review.update_attributes(rating: new_rating)
    # instead of attributes using columns to bypass validations
    if review
     review.update_column(:rating, new_rating)
    else
      review = Review.new(user: user, video: video, rating: new_rating)
      review.save(validate: false)
    end
  end

  def category_name
  	#video.video_categories.first.category.name
    queue_item_category.name
  end

  def queue_item_category
  	video.video_categories.first.category
  end

  private

  def review
    @review ||= Review.where(user_id: user.id, video_id: video.id).first
  end
end