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

end