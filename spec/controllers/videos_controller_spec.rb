require 'spec_helper'

describe VideosController do
  describe "user access" do
  before :each do
    user = User.create(username:"fake person", email: "facke@fake.com", password: "fakepassword")
    session[:user_id] = user.id
  end

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

  describe "GET search" do
    it "sets the @videos variable" do
      video = Video.create(title: "Frozen", description: "Disney Movie about two princess")
      get :search, search_title: "ro"
      assigns(:videos).should eq [video]
    end
    it "displays flash notice if @videos is an empty array" do
      video = Video.create(title: "Frozen", description: "Disney Movie about two princess")
      get :search, search_title: "sa"
      flash[:notice].should_not be_nil
    end
    it "redirects_to videos_path if @videos is an empty array" do
      video = Video.create(title: "Frozen", description: "Disney Movie about two princess")
      get :search, search_title: "sa"
      response.should redirect_to videos_path
    end
    it "renders :search template if @videos is not an empty array" do
      video = Video.create(title: "Frozen", description: "Disney Movie about two princess")
      get :search, search_title: "ro"
      response.should render_template :search
    end
  end
end
     
end