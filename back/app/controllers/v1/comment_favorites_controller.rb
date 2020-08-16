class V1::CommentFavoritesController < ApplicationController
  def show
    @commentFavorite = if params[:comment_id]
                         commentFavorites = CommentFavorite.where(comment_id: params[:comment_id])
                       else
                         CommentFavorite.all
                end
    render json: @commentFavorite
  end

  def create
    commentFavorite = CommentFavorite.create(user_id: params[:user_id], comment_id: params[:comment_id], shop_id: params[:shop_id])
    if commentFavorite.save
      render json: commentFavorite, status: :created
    else
      render json: commentFavorite.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if params[:user_id] && params[:comment_id]
      commentFavorite = CommentFavorite.find_by(user_id: params[:user_id], comment_id: params[:comment_id])
      commentFavorite.delete
      render json: { status: 'SUCCESS', message: 'delete comment commentFavorite' }
    else
      render json: { status: 'NOT_FOUND', message: 'can not delete comment commentFavorite' }
    end
  end
end
