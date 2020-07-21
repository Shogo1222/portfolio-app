class V1:: CommentsController < ApplicationController

def show
  if params[:shop_id]
    @comments = Comment.where(shop_id: params[:shop_id])
    render json: @comments
  else
    @comments = Comment.all
    render json: @comments
  end
end

def create
  comment = Comment.new(comment_params)
  if comment.save
    render json: comment, status: :created
  else
    render json: comment.errors, status: :unprocessable_entity
  end
end

private
  def comment_params
    params.require(:comment).permit(:user_id, :user_name, :shop_id, :comment)
  end

end
