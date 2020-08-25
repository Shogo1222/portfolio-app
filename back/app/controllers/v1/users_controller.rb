class V1::UsersController < ApplicationController
  def show
    @user = if params[:uid]
              User.find_by(uid: params[:uid])
            elsif params[:id]
              User.find_by(id: params[:id])
            elsif params[:ids]
              User.where(id: params[:ids])
            elsif params[:name]
              User.where('name LIKE ?', "%#{params[:name]}%").distinct
            else
              User.all
    end
    render json: @user.as_json
  end

  def create
    user = User.new(email: params[:email], uid: params[:uid], name: params[:name], image: params[:image])

    if user.save
      render json: user, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def update
    if params[:uid] && params[:image]
      @user = User.find_by(uid: params[:uid])
      if @user.update(email: params[:email], uid: params[:uid], name: params[:name], image: params[:image])
        render json: @user.as_json
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    elsif params[:uid] && !params[:image]
      @user = User.find_by(uid: params[:uid])
      if @user.update(email: params[:email], uid: params[:uid], name: params[:name])
        render json: @user.as_json
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if params[:uid]
      @user = User.find_by(uid: params[:uid])
      @user.delete
      render json: { status: 'SUCCESS', message: 'delete user' }
    else
      render json: { status: 'NOT_FOUND', message: 'can not delete user' }
    end
  end
end
