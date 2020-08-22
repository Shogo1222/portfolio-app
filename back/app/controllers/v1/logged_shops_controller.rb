class V1::LoggedShopsController < ApplicationController
  def show
    if params[:user_id] && params[:action_from]
      @logged_shop = LoggedShop.where(user_id: params[:user_id], action_from: params[:action_from])
      render json: @logged_shop.as_json
    else
      @logged_shop = LoggedShop.all.as_json
      render json: @logged_shop
    end
  end

  def create
    @logged_shop = LoggedShop.find_by(user_id: params[:user_id], action_from: params[:action_from], shop_id: params[:shop_id])
    if @logged_shop
      render json: @logged_shop.as_json, status: :created
    else
      @logged_shop = LoggedShop.create(
        user_id: params[:user_id],
        action_from: params[:action_from],
        shop_id: params[:shop_id],
        lat: params[:lat],
        lng: params[:lng],
        name: params[:name],
        catch: params[:catch],
        capacity: params[:capacity],
        photo: params[:photo],
        budget: params[:budget],
        budget_memo: params[:budget_memo],
        mobile_access: params[:mobile_access],
        open: params[:open],
        non_smoking: params[:non_smoking],
        address: params[:address]
      )
      if @logged_shop.save
        render json: @logged_shop, status: :created
      else
        render json: @logged_shop.errors, status: :unprocessable_entity
      end
  end
  end

  def destroy
    if params[:user_id] && params[:shop_id] && params[:action_from]
      @logged_shop = LoggedShop.find_by(user_id: params[:user_id], shop_id: params[:shop_id], action_from: params[:action_from])
      @logged_shop.delete
      render json: { status: 'SUCCESS', message: 'delete user logged_shop' }
    else
      render json: { status: 'NOT_FOUND', message: 'can not delete logged_shop' }
    end
  end
end
