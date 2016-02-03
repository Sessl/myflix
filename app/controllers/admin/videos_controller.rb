class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(admin_video_params)
    if @video.save
      flash[:success] = "You have successfully added the video '#{@video.title}'."
      redirect_to new_admin_video_path
    else
      flash[:error] = "Your attempt to add a video failed! Please check errors!"
      render :new
    end
  end

  private

  def admin_video_params
    params.require(:video).permit(:title, :description, :large_cover, :small_cover, :video_url, category_ids: [])
  end
end