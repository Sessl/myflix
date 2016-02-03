module ApplicationHelper

def options_for_video_ratings(selection = nil)
  options_for_select([["5 *****", 5], ["4 ****", 4], ["3 ***", 3], ["2 **", 2], ["1 *", 1]], selection)
end

def this_video_average_rating(some_video)
  if some_video.average_rating == 0
    return "Unrated"
  else
    return "#{some_video.average_rating}/5"
  end 
end
  
end
