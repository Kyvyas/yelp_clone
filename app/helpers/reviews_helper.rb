module ReviewsHelper
  def find_reviewer(review)
    User.find(review.user_id)
  end

  def star_rating(rating)
    return rating unless rating.respond_to?(:round)
    remainder = (5 - rating)
    "★" * rating.round + "☆" * remainder
  end
end
