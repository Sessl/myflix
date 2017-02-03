require 'spec_helper'

describe Video do
 # it "saves itself" do
 #   video = Video.new(title: "Lilo and Stitch", description: "Children love it")
 #   video.save
 #  expect(Video.last).to eq(video)
 # end 

 # it "should have many categories" do
 # 	video = Video.reflect_on_association(:categories)
 # 	video.macro.should == :has_many
 # end
  it { should have_many(:categories)}
  
  #it "is valid with title and description" do
  #	video = Video.new(title: "Jane Eyre", description: "adaptation of a book by Charlotte Bronte")
  #	expect(video).to be_valid
  #end
  
  #it "is invalid without a title" do
  #	expect(Video.new(title: nil)).to have(1).errors_on(:title)
  #end

  it { should validate_presence_of(:title)}

  #it "is invalid without a description" do
  #	expect(Video.new(description: nil)).to have(1).errors_on(:description)
  #end
  it { should validate_presence_of(:description)}

  describe "search_by_title" do

    before :each do
      @thor = Video.create(title: "Thor", description: "Thor visits earth")
      @thomas = Video.create(title: "The Thomas Crown Affair", description: "Crime romance thriller")
      @lilo = Video.create(title: "Lilo and Stitch", description: "Animation adventure for children")
    end

    context "input string is nil" do
      it "returns an empty array" do
        expect(Video.search_by_title(nil)).to eq []
      end
    end

    context "input string is empty" do
      it "returns an empty array" do
        expect(Video.search_by_title(" ")).to eq []
      end
    end
  
    context "string matches a single element" do
      it "returns a single element array if a single value is found" do
        expect(Video.search_by_title("st")).to eq [@lilo]
      end
    end

    context "string matches multiple elements" do
      it "returns an array with multiple elements for multiple matches" do
        expect(Video.search_by_title("tho")).to eq [@thor,@thomas]
      end
    end

    context "string search returns an empty array" do
      it "returns an empty array for no matches" do
        expect(Video.search_by_title("sa")).to eq []
      end
    end

    context "search result does not include non-matching elements" do
      it "does not return a non-matching value" do
        expect(Video.search_by_title("th")).to_not include @lilo
      end
    end


  end

  describe ".search", :elasticsearch do
    let(:refresh_index) do
      Video.import
      Video.__elasticsearch__.refresh_index!
    end

    context "with title" do
      it "returns no results when there's no match" do
        Fabricate(:video, title: "Futurama")
        refresh_index
        expect(Video.search("whatever").records.to_a).to eq([])
      end
      it "returns an empty array when there's no search term" do
        futurama = Fabricate(:video)
        south_park = Fabricate(:video)
        refresh_index
        expect(Video.search("").records.to_a).to eq([])
      end
      it "returns an array of 1 video for title case insensitive match" do
        futurama = Fabricate(:video, title: "Futurama")
        south_park = Fabricate(:video, title: "South Park")
        refresh_index
        expect(Video.search("futurama").records.to_a).to eq([futurama])
      end
      it "returns an array of many videos for title match" do
        star_trek = Fabricate(:video, title: "Star Trek")
        star_wars = Fabricate(:video, title: "Star Wars")
        refresh_index
        expect(Video.search("star").records.to_a).to match_array [star_trek, star_wars]
      end
    end

    context "with title and description" do
      it "returns an array of many videos based on title and description match" do
        star_wars = Fabricate(:video, title: "Star Wars")
        about_sun = Fabricate(:video, description: "sun is a star")
        refresh_index
        expect(Video.search("star").records.to_a).to match_array [star_wars, about_sun]
      end
    end

    context "multiple words must match" do
      it "returns an array of videos where 2 words match title" do
        star_wars1 = Fabricate(:video, title: "Star Wars: Episode 1")
        star_wars2 = Fabricate(:video, title: "Star Wars: Episode 2")
        bride_wars = Fabricate(:video, title: "Bride Wars")
        star_trek = Fabricate(:video, title: "Star Trek")
        refresh_index
        expect(Video.search("Star Wars").records.to_a).to match_array [star_wars1, star_wars2]
      end
    end

    context "with title, description and reviews" do
      it 'returns an an empty array for no match with reviews option' do
        star_wars = Fabricate(:video, title: "Star Wars")
        batman    = Fabricate(:video, title: "Batman")
        batman_review = Fabricate(:review, video: batman, content: "such a star movie!")
        refresh_index

        expect(Video.search("no_match", reviews: true).records.to_a).to eq([])
      end

      it 'returns an array of many videos with relevance title > description > review' do
        star_wars = Fabricate(:video, title: "Star Wars")
        about_sun = Fabricate(:video, description: "the sun is a star!")
        batman    = Fabricate(:video, title: "Batman")
        batman_review = Fabricate(:review, video: batman, content: "such a star movie!")
        refresh_index

        expect(Video.search("star", reviews: true).records.to_a).to eq([star_wars, about_sun, batman])
      end
    end

    context "filter with average ratings" do
      let(:star_wars_1) { Fabricate(:video, title: "Star Wars 1") }
      let(:star_wars_2) { Fabricate(:video, title: "Star Wars 2") }
      let(:star_wars_3) { Fabricate(:video, title: "Star Wars 3") }

      before do
        Fabricate(:review, rating: "2", video: star_wars_1)
        Fabricate(:review, rating: "4", video: star_wars_1)
        Fabricate(:review, rating: "4", video: star_wars_2)
        Fabricate(:review, rating: "2", video: star_wars_3)
        refresh_index
      end

      context "with only rating_from" do
        it "returns an empty array when there are no matches" do
          expect(Video.search("Star Wars", rating_from: "4.1").records.to_a).to eq []
        end

        it "returns an array of one video when there is one match" do
          expect(Video.search("Star Wars", rating_from: "4.0").records.to_a).to eq [star_wars_2]
        end

        it "returns an array of many videos when there are multiple matches" do
          expect(Video.search("Star Wars", rating_from: "3.0").records.to_a).to match_array [star_wars_2, star_wars_1]
        end
      end

      context "with only rating_to" do
        it "returns an empty array when there are no matches" do
          expect(Video.search("Star Wars", rating_to: "1.5").records.to_a).to eq []
        end

        it "returns an array of one video when there is one match" do
          expect(Video.search("Star Wars", rating_to: "2.5").records.to_a).to eq [star_wars_3]
        end

        it "returns an array of many videos when there are multiple matches" do
          expect(Video.search("Star Wars", rating_to: "3.4").records.to_a).to match_array [star_wars_1, star_wars_3]
        end
      end

      context "with both rating_from and rating_to" do
        it "returns an empty array when there are no matches" do
          expect(Video.search("Star Wars", rating_from: "3.4", rating_to: "3.9").records.to_a).to eq []
        end

        it "returns an array of one video when there is one match" do
          expect(Video.search("Star Wars", rating_from: "1.8", rating_to: "2.2").records.to_a).to eq [star_wars_3]
        end

        it "returns an array of many videos when there are multiple matches" do
          expect(Video.search("Star Wars", rating_from: "2.9", rating_to: "4.1").records.to_a).to match_array [star_wars_1, star_wars_2]
        end
      end

    end

  end

end