class V1::VisitedShopsController < ApplicationController
  def show
    @visited_shops = if params[:user_id] && params[:shop_id]
                       VisitedShop
                         .select('visited_shops.*, logged_shops.shop_id')
                         .joins('JOIN logged_shops ON logged_shops.id = visited_shops.logged_shop_id')
                         .where(user_id: params[:user_id], logged_shops: { shop_id: params[:shop_id] })
                     elsif params[:user_id]
                       VisitedShop.where(user_id: params[:user_id])
                     else
                       []
                end
    render json: @visited_shops
  end

  def create
    @visited_shops = VisitedShop.create(
      user_id: params[:user_id],
      logged_shop_id: params[:logged_shop_id]
    )
    if @visited_shops.save
      render json: @visited_shops, status: :created
    else
      render json: @visited_shops.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if params[:user_id] && params[:shop_id] && params[:logged_shop_id]
      @visited_shops = VisitedShop
                       .joins('JOIN logged_shops ON logged_shops.id = visited_shops.logged_shop_id')
                       .find_by(user_id: params[:user_id], logged_shops: { shop_id: params[:shop_id] }, logged_shop_id: params[:logged_shop_id])
      @visited_shops.delete
      render json: { status: 'SUCCESS', message: 'delete visited_shops' }
    else
      render json: { status: 'NOT_FOUND', message: 'can not delete post' }
    end
  end
end
