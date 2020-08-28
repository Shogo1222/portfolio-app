class V1::ShopTagsController < ApplicationController
  def show
    @shop_tag = if params[:shop_id]
                  ShopTag.select('logged_shops.shop_id, shop_tags.tag').joins('JOIN logged_shops ON logged_shops.id = shop_tags.logged_shop_id')
                         .where(logged_shops: { shop_id: params[:shop_id] }).distinct
                elsif params[:tag]
                  ShopTag.select('logged_shops.shop_id, shop_tags.tag').joins('JOIN logged_shops ON logged_shops.id = shop_tags.logged_shop_id')
                         .where('shop_tags.tag LIKE ?', "%#{params[:tag]}%").distinct
                else
                  []
    end
    render json: @shop_tag
  end

  def recent_tag
    @shop_tag = if params[:shop_id] && params[:tag]
                  ShopTag.select('shop_tags.tag').joins('JOIN logged_shops ON logged_shops.id = shop_tags.logged_shop_id')
                         .where.not(logged_shops: { shop_id: params[:shop_id] }).where('shop_tags.tag LIKE ?', "%#{params[:tag]}%").limit(5).distinct
                elsif params[:shop_id]
                  ShopTag.select('shop_tags.tag').joins('JOIN logged_shops ON logged_shops.id = shop_tags.logged_shop_id')
                         .where.not(logged_shops: { shop_id: params[:shop_id] }).limit(5).distinct
                else
                  ShopTag.all.limit(5)
    end
    render json: @shop_tag
   end

  def create
    @shop_tag = ShopTag.create(tag: params[:tag], logged_shop_id: params[:logged_shop_id])
    if @shop_tag.save
      render json: @shop_tag, status: :created
    else
      render json: @shop_tag.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if params[:shop_id] && params[:tag]
      @shop_tag = ShopTag
                  .joins('JOIN logged_shops ON logged_shops.id = shop_tags.logged_shop_id')
                  .find_by(logged_shops: { shop_id: params[:shop_id] }, tag: params[:tag])
      @shop_tag.delete
      @exist_shop_tag = ShopTag
                        .joins('JOIN logged_shops ON logged_shops.id = shop_tags.logged_shop_id')
                        .find_by(logged_shops: { shop_id: params[:shop_id] })
      render json: @exist_shop_tag, status: :ok
    else
      render json: { status: 'NOT_FOUND', message: 'can not delete user tag' }
    end
  end
end
