class Video < ActiveRecord::Base
include Elasticsearch::Model
include Elasticsearch::Model::Callbacks 
index_name ["myflix", Rails.env].join('_')

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
  self.reviews.average(:rating).to_f.round(1) if reviews.any?
end

def self.search(query, options={})
  search_definition = {
    query: {
      multi_match: {
        query: query,
        fields: ["title^100", "description^50"],
        operator: "and"
      }
    }
  }

  if query.present? && options[:reviews].present?
    search_definition[:query][:multi_match][:fields] << "reviews.content"
  end

  if options[:rating_from].present? || options[:rating_to].present?
    search_definition[:filter] = {
      range: {
        average_rating: {
        gte: (options[:rating_from] if options[:rating_from].present?),
        lte: (options[:rating_to] if options[:rating_to].present?)
        }
      }
    }
  end

  __elasticsearch__.search(search_definition)
end

def as_indexed_json(options={})
	as_json(
    methods: [:average_rating],
    only: [:title, :description],
    include: {
      reviews: {only: [:content]}
      }
    )
end
    
end