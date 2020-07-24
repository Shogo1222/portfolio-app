class V1:: CommentsController < ApplicationController

def show
  if params[:shop_id]
    @comments = Comment.where(shop_id: params[:shop_id])
  else
    @comments = Comment.all
  end
  render json: @comments
end

def create
  comment = Comment.new(
    user_id: params[:user_id],
    user_name: params[:user_name],
    shop_id: params[:shop_id],
    comment: params[:comment]
  )
  if comment.save
    render json: comment, status: :created
  else
    render json: comment.errors, status: :unprocessable_entity
  end
end
end
