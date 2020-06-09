class V1::FavoritesController < ApplicationController

  def show
    if params[:user_id] && params[:shop_id]
      @favorite = Favorite.find_by(user_id: params[:user_id], shop_id: params[:shop_id])
      render json: @favorite
    else
      @favorite = Favorite.all
      render json: @favorite
    end
  end

  def create
    favorite = Favorite.new(favorite_params)
    if favorite.save
      render json: favorite, status: :created
    else
      render json: favorite.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if params[:user_id] && params[:shop_id]
      favorite = Favorite.find_by(user_id: params[:user_id], shop_id: params[:shop_id])
      favorite.delete
      render json: { status: 'SUCCESS', message: 'delete favorite' }
    else
      render json: { status: 'NOT_FOUND', message: 'can not delete post' }
    end
  end

  private
    def favorite_params
      params.require(:favorite).permit(:user_id, :shop_id)
    end
end
