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
    end

end