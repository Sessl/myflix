class Video < ActiveRecord::Base
has_many :video_categories
has_many :categories, through: :video_categories
has_many :reviews

mount_uploader :large_cover, LargeCoverUploader
mount_uploader :small_cover, SmallCoverUploader

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
  if self.reviews.average(:rating)
    average = self.reviews.average(:rating)
  else
    average = 0
  end
end
 

    
end