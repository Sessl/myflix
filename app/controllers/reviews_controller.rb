class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @video = Video.find(params[:video_id])
    @review = @video.reviews.build(params.require(:review).permit(:content, :rating).merge!(user: current_user))
    #@review.user = current_user chaining the method merge instead
    if @review.save
      flash[:notice] = "Your review was saved"
      redirect_to video_path(@video)
    else
      @reviews = @video.reviews.reload.latest_reviews
      render "videos/show"
    end
  end  

end