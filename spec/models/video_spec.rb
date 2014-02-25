require 'spec_helper'

describe Video do
  it "saves itself" do
    video = Video.new(title: "Lilo and Stitch", description: "Children love it")
    video.save
    expect(Video.last).to eq(video)
  end 
end