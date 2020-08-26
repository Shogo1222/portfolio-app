class V1::NotificationsController < ApplicationController
  def show
    @notification = if params[:user_id]
                      Notification
                        .where(user_id: params[:user_id], is_opened: false)
                        .order(created_at: 'DESC')
                    else
                      []
                end
    render json: @notification
  end

  def create
    @notification = Notification.create(
      user_id: params[:user_id],
      is_opened: false,
      action_from: params[:action_from],
      follow_relationship_id: params[:follow_relationship_id] || 0,
      invitation_id: params[:invitation_id] || 0
    )
    if @notification.save
      render json: @notification, status: :created
    else
      render json: @notification.errors, status: :unprocessable_entity
    end
  end

  def update
    @notification = Notification
                    .where(user_id: params[:user_id], action_from: params[:action_from], is_opened: false)
    if @notification.update_all(is_opened: true)
      render json: @notification
    else
      render json: { status: 'NOT_FOUND', message: 'can not update notifications' }
    end
  end
end
