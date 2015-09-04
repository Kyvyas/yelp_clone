class ReviewsController < ApplicationController

	def new
		@restaurant = Restaurant.find(params[:restaurant_id])
		@review = Review.new
		p current_user.reviewed_restaurants
	end

	def review_params
	  params.require(:review).permit(:thoughts, :rating)
	end

	def create
	  @restaurant = Restaurant.find params[:restaurant_id]
	  @review = @restaurant.build_review review_params, current_user

	  if @review.save
	    redirect_to restaurants_path
	  else
	    if @review.errors[:user]
	      redirect_to restaurants_path, alert: 'You have already reviewed this restaurant'
	    else
	      render :new
	    end
	  end
	end

	def destroy
		@review = Review.find(params[:id])
		if current_user.id == @review.user_id
	    @review.destroy
	  else
	  	flash[:notice] = 'You did not write this review'
	  end
	  redirect_to restaurants_path
	end
end
