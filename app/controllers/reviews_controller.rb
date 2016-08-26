class ReviewsController < ApplicationController
  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    if current_user.has_reviewed?(@restaurant)
      flash[:notice] = "You have already reviewed this restaurant"
      redirect_to restaurants_path
    else
      @review = Review.new
    end
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = @restaurant.reviews.build_with_user(review_params, current_user)

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
    if @review.user != current_user
      flash[:notice] = 'Cannot delete someone else\'s review'
    else
      @review.destroy
      flash[:notice] = 'Review deleted successfully'
    end
    redirect_to restaurants_path
  end

  private

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end

end
