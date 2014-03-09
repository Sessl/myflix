require 'spec_helper'

describe VideosController do
  describe "GET show" do
    it "sets the @video variable" do
      video = Video.create(title: "Frozen", description: "Disney Movie about two princesses")
      get :show, id: video.id
      assigns(:video).should eq(video)
    end

    it "renders the :show template" do
       video = Video.create(title: "Frozen", description: "Disney Movie about two princesses")
       get :show, id: video.id
       response.should render_template :show 
    end
  end
    
end