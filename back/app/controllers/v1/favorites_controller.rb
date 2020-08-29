class V1::FavoritesController < ApplicationController
  def show
    @favorite = if params[:user_id] && params[:shop_id]
                  Favorite
                    .select('favorites.*, logged_shops.shop_id')
                    .joins('JOIN logged_shops ON logged_shops.id = favorites.logged_shop_id')
                    .where(user_id: params[:user_id], logged_shops: { shop_id: params[:shop_id] })
                elsif params[:user_id]
                  Favorite.where(user_id: params[:user_id]) || []
                else
                  []
                end
    render json: @favorite
  end

  def create
    @favorite = Favorite.create(
      user_id: params[:user_id],
      logged_shop_id: params[:logged_shop_id]
    )
    if @favorite.save
      render json: @favorite, status: :created
    else
      render json: @favorite.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if params[:user_id] && params[:shop_id] && params[:logged_shop_id]
      @favorite = Favorite.joins('JOIN logged_shops ON logged_shops.id = favorites.logged_shop_id')
                          .find_by(user_id: params[:user_id], logged_shops: { shop_id: params[:shop_id] }, logged_shop_id: params[:logged_shop_id])
      @favorite.delete
      render json: { status: 'SUCCESS', message: 'delete favorite' }
    else
      render json: { status: 'NOT_FOUND', message: 'can not delete post' }
    end
  end
end
