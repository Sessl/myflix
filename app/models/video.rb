class Video < ActiveRecord::Base
has_many :video_categories
has_many :categories, through: :video_categories
has_many :reviews

validates :title, presence: true
validates :description, presence: true

  def self.search_by_title(search_title) 
    if search_title.blank?
      return []
    else    
      where("title LIKE ?", "%#{search_title}%")
    end
  end

  def average_rating 
    total = 0
      self.reviews.each do |review|
        total += review.rating
      end
    average = ((total.to_f)/self.reviews.count).round(1)
  end
 
  
    
end