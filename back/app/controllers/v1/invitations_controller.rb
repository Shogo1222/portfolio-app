class V1::InvitationsController < ApplicationController
  def show
    @invitation = if params[:user_id]
                    User.joins('JOIN invitations ON users.id = invitations.user_id')
                        .joins('JOIN logged_shops ON invitations.logged_shop_id = logged_shops.id')
                        .select(
                          'users.id AS id',
                          'users.name',
                          'users.image',
                          'invitations.user_id',
                          'invitations.to_user_id',
                          'invitations.id AS invitation_id',
                          'invitations.created_at AS invitation_created_at',
                          'logged_shops.name AS shop_name',
                          'logged_shops.shop_id',
                          'logged_shops.catch AS catch_copy',
                          'logged_shops.lat',
                          'logged_shops.lng',
                          'logged_shops.capacity',
                          'logged_shops.photo',
                          'logged_shops.budget',
                          'logged_shops.budget_memo',
                          'logged_shops.mobile_access',
                          'logged_shops.open AS open_hour',
                          'logged_shops.non_smoking',
                          'logged_shops.address'
                        )
                        .where(invitations: { to_user_id: params[:user_id] })
                        .order(invitation_created_at: 'DESC')
                  else
                    []
                end
    render json: @invitation.as_json
  end

  def create
    @invitation = Invitation.create(
      user_id: params[:user_id],
      to_user_id: params[:to_user_id],
      logged_shop_id: params[:logged_shop_id]
    )
    if @invitation.save
      render json: @invitation, status: :created
    else
      render json: @invitation.errors, status: :unprocessable_entity
    end
  end
end
