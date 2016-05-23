class VideoDecorator < Draper::Decorator
delegate_all

def rating
  if object.reviews.average(:rating)
    "#{object.reviews.average(:rating)}/5"
  else
    "Unrated"
  end
end

end