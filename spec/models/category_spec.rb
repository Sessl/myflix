require 'spec_helper'

describe Category do
  it "saves itself" do
    category = Category.new(name: "Romance")
    category.save
    expect(Category.last).to eq(category)
  end

  it "should have many videos" do
    category = Category.reflect_on_association(:videos)
    category.macro.should == :has_many
  end
end