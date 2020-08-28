class V1::FollowRelationshipsController < ApplicationController
  def show
    @followRelationship = if params[:user_id] && params[:following_user_id]
                            FollowRelationship.find_by(user_id: params[:user_id], following_user_id: params[:following_user_id])
                          elsif params[:user_id]
                            FollowRelationship.where(user_id: params[:user_id]).order(created_at: 'DESC')
                          elsif params[:following_user_id]
                            FollowRelationship.where(following_user_id: params[:following_user_id]).order(created_at: 'DESC')
                          else
                            []
    end
    render json: @followRelationship
  end

  def create
    @followed = FollowRelationship.find_by(user_id: params[:following_user_id], following_user_id: params[:user_id])
    @is_mutual_follow = if @followed
                          true
                          @followed.update(
                            user_id: params[:following_user_id],
                            following_user_id: params[:user_id],
                            is_mutual_follow: true
                          )
                        else
                          false
                        end

    @followRelationship = FollowRelationship.create(
      user_id: params[:user_id],
      following_user_id: params[:following_user_id],
      is_mutual_follow: @is_mutual_follow
    )
    if @followRelationship.save
      render json: @followRelationship, status: :created
    else
      render json: @followRelationship.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if params[:user_id] && params[:following_user_id]
      @followRelationship = FollowRelationship.find_by(
        user_id: params[:user_id],
        following_user_id: params[:following_user_id]
      )
      @followRelationship.delete
      render json: { status: 'SUCCESS', message: 'delete FollowRelationship' }
    else
      render json: { status: 'NOT_FOUND', message: 'can not delete FollowRelationship' }
    end
  end
end
