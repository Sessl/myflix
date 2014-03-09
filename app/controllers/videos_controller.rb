class VideosController < ApplicationController
  #before_action :require_user, except: [:front]
  
  def front
    redirect_to home_path if current_user
  end

  def index
    @categories = Category.all  
  end


  def show
    @video = Video.find(params[:id])
  end

  def search
    @videos = Video.search_by_title(params[:search_title])
    if @videos == []
        flash[:notice]= "No videos matched your search"
        redirect_to videos_path
    else
       render 'search'
    end
  end

  private

  def video_params
    params.require(:video).permit(:search_title)
  end
end
