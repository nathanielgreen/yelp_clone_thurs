class ReviewsController < ApplicationController

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find params[:restaurant_id]
    # @restaurant = current_user.restaurants.new(restaurant_params)
    @review = @restaurant.build_review_with_user(review_params, current_user)

    if @review.save
      redirect_to restaurants_path
    else
      if @review.errors[:user]
        # this should never happen...
        redirect_to restaurants_path, alert: 'You have already reviewed this restaurant'
      else
        render :new
      end
    end
  end

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    flash[:notice] = "Review deleted successfully"
    redirect_to '/restaurants'
  end

end
