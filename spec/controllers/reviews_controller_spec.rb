require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    let(:video) { Fabricate(:video)}

    context "user signed in" do
      let(:current_user) { Fabricate(:user) }
      before { session[:user_id] = current_user.id }

        context "with valid inputs" do
          it "re-directs to video_path once review is saved" do
           # video = Video.create(title: "Frozen", description: "Disney Movie about two princesses")
            post :create, review: Fabricate.attributes_for(:review), video_id: video.id
            expect(response).to redirect_to video
          end
          it "sets the @review variable" do
           #video =  Video.create(title: "Frozen", description: "Disney Movie about two princesses")
           post :create, review: Fabricate.attributes_for(:review), video_id: video.id
             expect(Review.count).to eq(1)
          end
          it "creates a review associated with the video" do
           #video =  Video.create(title: "Frozen", description: "Disney Movie about two princesses")
           post :create, review: Fabricate.attributes_for(:review), video_id: video.id
           expect(Review.first.video_id).to eq(video.id)
          end
          it "creates a review associated with the signed in user" do
            #video = Video.create(title: "Frozen", description: "Disney Movie about two princesses")
            post :create, review: Fabricate.attributes_for(:review), video_id: video.id
            expect(Review.first.user).to eq(current_user)
          end
          it "displays message if review is saved" do
           # video =  Video.create(title: "Frozen", description: "Disney Movie about two princesses")
            post :create, review: Fabricate.attributes_for(:review), video_id: video.id
            expect(flash[:notice]).to_not be_nil 
          end
        end

        context "with invalid inputs" do
          it "does not create review with invalid input" do
            #video = Video.create(title: "Frozen", description: "Disney Movie about two princesses")
            post :create, review: {rating: 4}, video_id: video.id
            expect(Review.count).to eq(0)
          end
          
          it "renders 'videos/show' if review is not saved" do
           # video = Video.create(title: "Frozen", description: "Disney Movie about two princesses")
            post :create, review: {rating: 4}, video_id: video.id
            expect(response).to render_template "videos/show"
          end

          it "sets @video" do
           # video = Video.create(title: "Frozen", description: "Disney Movie about two princesses")
            post :create, review: {rating: 4}, video_id: video.id
            expect(assigns(:video)).to eq(video)
          end

          it "sets @reviews" do
           # video = Video.create(title: "Frozen", description: "Disney Movie about two princesses")
            review = Fabricate(:review, video: video)
            post :create, review: {rating: 4}, video_id: video.id
            expect(assigns(:reviews)).to match_array([review])
          end

        end
    end

    context "user not signed in" do
      it "should re-direct to the sign in path" do
       # video =  Video.create(title: "Frozen", description: "Disney Movie about two princesses")
        post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        expect(response).to redirect_to sign_in_path
      end
    end
    
  end   
end