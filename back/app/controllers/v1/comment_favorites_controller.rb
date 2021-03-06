class V1::CommentFavoritesController < ApplicationController
  def show
    @commentFavorites = if params[:comment_id]
                          CommentFavorite
                            .joins('JOIN comments ON comments.id = comment_favorites.comment_id')
                            .joins('JOIN logged_shops ON logged_shops.id = comments.logged_shop_id')
                            .where(comment_id: params[:comment_id])
                        else
                          []
                        end
    render json: @commentFavorites
  end

  def create
    @commentFavorite = CommentFavorite.create(user_id: params[:user_id], comment_id: params[:comment_id])
    if @commentFavorite.save
      render json: @commentFavorite, status: :created
    else
      render json: @commentFavorite.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if params[:user_id] && params[:comment_id]
      @commentFavorite = CommentFavorite.find_by(user_id: params[:user_id], comment_id: params[:comment_id])
      @commentFavorite.delete
      render json: { status: 'SUCCESS', message: 'delete comment commentFavorite' }
    else
      render json: { status: 'NOT_FOUND', message: 'can not delete comment commentFavorite' }
    end
  end
end
