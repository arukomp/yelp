class RestaurantsController < ApplicationController
  before_action :authenticate_user!, :except => [:index, :show]

  def index
     @restaurants = Restaurant.all
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user = current_user
    if @restaurant.save
      redirect_to restaurants_path
    else
      render 'new'
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.user != current_user
      flash[:notice] = "Cannot edit someone else's restaurant"
      redirect_to restaurants_path
    end
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.user == current_user
      @restaurant.update(restaurant_params)
    else
      flash[:notice] = "Cannot edit someone else's restaurant"
    end
    redirect_to restaurants_path
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.user != current_user
      flash[:notice] = "Cannot delete someone else's restaurant"
    else
      @restaurant.destroy
      flash[:notice] = 'Restaurant deleted successfully'
    end
    redirect_to restaurants_path
  end

  private

  def restaurant_params
     params.require(:restaurant).permit(:name, :description)
  end

end
