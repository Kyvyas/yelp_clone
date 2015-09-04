module ReviewsHelper
  def find_reviewer(review)
    User.find(review.user_id)
  end
end
