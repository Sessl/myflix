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

end