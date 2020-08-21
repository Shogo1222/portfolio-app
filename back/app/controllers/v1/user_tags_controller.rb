class V1::UserTagsController < ApplicationController
  def show
    if params[:user_id]
      @user_tag = UserTag.select(:user_id, :tag).where(user_id: params[:user_id]).distinct
      render json: @user_tag.as_json
    else
      @user_tag = UserTag.all.as_json
      render json: @user_tag
    end
  end

  def recent_tag
    if params[:user_id] && params[:tag]
      @user_tag = UserTag.select(:tag).where.not(user_id: params[:user_id]).where('tag LIKE ?', "%#{params[:tag]}%").limit(5).distinct
      render json: @user_tag.as_json
    elsif params[:user_id]
      @user_tag = UserTag.select(:user_id, :tag).where.not(user_id: params[:user_id]).limit(5).distinct
      render json: @user_tag.as_json
    else
      @user_tag = UserTag.all.limit(5)
      render json: @user_tag.as_json
    end
   end

  def create
    @user_tag = UserTag.create(user_id: params[:user_id], tag: params[:tag])
    if @user_tag.save
      render json: @user_tag, status: :created
    else
      render json: @user_tag.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if params[:user_id] && params[:tag]
      @user_tag = UserTag.find_by(user_id: params[:user_id], tag: params[:tag])
      @user_tag.delete
      render json: { status: 'SUCCESS', message: 'delete user tag' }
    else
      render json: { status: 'NOT_FOUND', message: 'can not delete user tag' }
    end
  end
end
