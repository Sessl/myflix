require 'spec_helper'

describe Video do
  it "saves itself" do
    video = Video.new(title: "Lilo and Stitch", description: "Children love it")
    video.save
    expect(Video.last).to eq(video)
  end 

  it "should have many categories" do
  	video = Video.reflect_on_association(:categories)
  	video.macro.should == :has_many
  end
  
  it "is valid with title and description" do
  	video = Video.new(title: "Jane Eyre", description: "adaptation of a book by Charlotte Bronte")
  	expect(video).to be_valid
  end
  
  it "is invalid without a title" do
  	expect(Video.new(title: nil)).to have(1).errors_on(:title)
  end

  it "is invalid without a description" do
  	expect(Video.new(description: nil)).to have(1).errors_on(:description)
  end
end