class V1::ShopTagsController < ApplicationController
  def show
    @shop_tag = if params[:shop_id]
                  ShopTag.select(:shop_id, :tag).where(shop_id: params[:shop_id]).distinct
                elsif params[:tag]
                  ShopTag.select(:shop_id, :tag).where('tag LIKE ?', "%#{params[:tag]}%").distinct
                else
                  ShopTag.all
    end
    render json: @shop_tag
  end

  def recent_tag
    if params[:shop_id] && params[:tag]
      @shop_tag = ShopTag.select(:tag).where.not(shop_id: params[:shop_id]).where('tag LIKE ?', "%#{params[:tag]}%").limit(5).distinct
      render json: @shop_tag.as_json
    elsif params[:shop_id]
      @shop_tag = ShopTag.select(:shop_id, :tag).where.not(shop_id: params[:shop_id]).limit(5).distinct
      render json: @shop_tag.as_json
    else
      @shop_tag = ShopTag.all.limit(5)
      render json: @shop_tag.as_json
    end
   end

  def create
    @shop_tag = ShopTag.create(shop_id: params[:shop_id], tag: params[:tag], logged_shop_id: params[:logged_shop_id])
    if @shop_tag.save
      render json: @shop_tag, status: :created
    else
      render json: @shop_tag.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if params[:shop_id] && params[:tag]
      @shop_tag = ShopTag.find_by(shop_id: params[:shop_id], tag: params[:tag])
      @shop_tag.delete
      @exist_shop_tag = ShopTag.find_by(shop_id: params[:shop_id])
      render json: @exist_shop_tag, status: :ok
    else
      render json: { status: 'NOT_FOUND', message: 'can not delete user tag' }
    end
  end
end
