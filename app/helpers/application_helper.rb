module ApplicationHelper

	def latest_reviews
     self.order("created_at DESC")
    end
end
