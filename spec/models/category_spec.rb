require 'spec_helper'

describe Category do
#  it "saves itself" do
#    category = Category.new(name: "Romance")
#    category.save
#    expect(Category.last).to eq(category)
#  end

#  it "should have many videos" do
#   category = Category.reflect_on_association(:videos)
#    category.macro.should == :has_many
#  end
  it { should have_many(:videos)}

  describe "recent_videos" do

    before :each do
        @category = Category.create(name: "Comedy")
        @category2 = Category.create(name: "Action")
        @category3 = Category.create(name: "Sports")
        @thor = Video.create(title: "Thor", description: "Thor visits earth", created_at: 1.year.ago)
        @thomas = Video.create(title: "The Thomas Crown Affair", description: "Crime romance thriller", created_at: 1.month.ago)
        @lilo = Video.create(title: "Lilo and Stitch", description: "Animation adventure for children", created_at: 2.year.ago)
        @beauty = Video.create(title: "Beauty and the Beast", description: "Disney animation", created_at: 1.day.ago)
        @spider = Video.create(title: "Spider Man", description: "Action adventure", created_at: 3.year.ago)
        @iron = Video.create(title: "Iron Man", description: "Action adventure", created_at: 6.month.ago)
        @flush = Video.create(title: "Flushed Away", description: "Animated action adventure")
        
        @thor.categories << @category
        @thomas.categories << @category
        @lilo.categories << @category
        @beauty.categories << @category
        @spider.categories << @category
        @iron.categories << @category
        @flush.categories << @category
        @spider.categories << @category2
        @iron.categories << @category2
        @thor.categories << @category2 
    end

    context "calling for videos ordered by created_at" do
      it "returns the most recently added videos" do        
        expect(@category.recent_videos).to eq [@flush, @beauty, @thomas, @iron, @thor, @lilo]
      end
    end

    context "when there are more than six results" do
      it "only returns six of the most recently added videos" do  
        expect(@category.recent_videos.count).to eq(6)
      end
    end

    context "search result does not include more than six results" do
      it "only returns six of the most recently added videos" do 
        expect(@category.recent_videos).to_not include @spider
      end
    end

    context "when there are less than six matching videos" do
      it "returns less than six if matching videos are less than six" do
        expect(@category2.recent_videos).to eq [@iron, @thor, @spider]
      end
    end
    
    context "when there are no matching videos" do
      it "returns an empty array if category has no videos" do
        expect(@category3.recent_videos).to eq []
      end
    end

  end

end