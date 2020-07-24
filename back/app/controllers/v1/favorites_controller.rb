class V1::FavoritesController < ApplicationController
  def show
    @favorite = if params[:user_id] && params[:shop_id]
                  Favorite.find_by(user_id: params[:user_id], shop_id: params[:shop_id])
                else
                  Favorite.all
                end
    render json: @favorite
  end

  def create
    favorite = Favorite.create(user_id: params[:user_id], shop_id: params[:shop_id])
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
end
