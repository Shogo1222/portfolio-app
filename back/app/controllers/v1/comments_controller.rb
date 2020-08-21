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
    if params[:id]
      @comment = Comment.find(params[:id])
      @comment.delete
      render json: { status: 'SUCCESS', message: 'delete comment' }
    else
      render json: { status: 'NOT_FOUND', message: 'can not delete comment' }
    end
  end
end
