require 'spec_helper'

describe Video do
  it "saves itself" do
    video = Video.new(title: "Lilo and Stitch", description: "Children love it")
    video.save
    Video.last.title.should == "Lilo and Stitch"
  end 
end