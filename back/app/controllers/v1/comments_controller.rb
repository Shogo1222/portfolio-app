class V1:: CommentsController < ApplicationController
  def show
    @comments = if params[:shop_id]
                  Comment.where(shop_id: params[:shop_id])
                else
                  Comment.all
                end
    render json: @comments
  end

  def create
    @comment = Comment.new(
      user_id: params[:user_id],
      user_name: params[:user_name],
      logged_shop_id: params[:logged_shop_id],
      shop_id: params[:shop_id],
      comment: params[:comment],
      image: params[:image]
    )
    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if params[:id] && params[:shop_id] && params[:user_id]
      @comment = Comment.find(params[:id])
      @comment.delete
      @exist_comment = Comment.where(shop_id: params[:shop_id], user_id: params[:user_id])
      render json: @exist_comment, status: :ok
    else
      render json: { status: 'NOT_FOUND', message: 'can not delete comment' }
    end
  end
end
