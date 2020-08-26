# frozen_string_literal: true

require 'rails_helper'

describe 'Notification' do
  before(:each) do
    @status_code_ok = 200
  end
  it '通知を表示1' do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user1.id)
    @invitation = FactoryBot.create(
      :invitation,
      user_id: @user1.id,
      to_user_id: @user2.id,
      logged_shop_id: @logged_shop.id,
      shop_id: 'test'
    )
    @notification = FactoryBot.create(
      :notification,
      user_id: @user2.id,
      is_opened: false,
      action_from: 'test',
      follow_relationship_id: 0,
      invitation_id: @invitation.id
    )
    @params = { user_id: @user2.id }
    get '/v1/notification', params: @params
    @json = JSON.parse(response.body)
    # responseの可否判定
    expect(response.status).to eq(@status_code_ok)
    # 入力したデータとの整合性判定
    expect(@json[0]['user_id']).to eq(@user2.id)
    expect(@json[0]['is_opened']).to eq(false)
    expect(@json[0]['action_from']).to eq('test')
    expect(@json[0]['invitation_id']).to eq(@invitation.id)
  end

  it '通知を表示2' do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @followRelationship = FactoryBot.create(
      :follow_relationship,
      user_id: @user1.id,
      following_user_id: @user2.id
    )
    @notification = FactoryBot.create(
      :notification,
      user_id: @user2.id,
      is_opened: false,
      action_from: 'test',
      follow_relationship_id: @followRelationship.id,
      invitation_id: 0
    )
    @params = { user_id: @user2.id }
    get '/v1/notification', params: @params
    @json = JSON.parse(response.body)
    # responseの可否判定
    expect(response.status).to eq(@status_code_ok)
    # 入力したデータとの整合性判定
    expect(@json[0]['user_id']).to eq(@user2.id)
    expect(@json[0]['is_opened']).to eq(false)
    expect(@json[0]['action_from']).to eq('test')
    expect(@json[0]['follow_relationship_id']).to eq(@followRelationship.id)
  end

  it '通知を追加' do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @followRelationship = FactoryBot.create(
      :follow_relationship,
      user_id: @user1.id,
      following_user_id: @user2.id
    )
    @params = {
      user_id: @user2.id,
      is_opened: false,
      action_from: 'test',
      follow_relationship_id: @followRelationship.id,
      invitation_id: 0
    }
    expect { post '/v1/notification/', params: @params }.to change(Notification, :count).by(+1)
  end

  it '通知を更新' do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @followRelationship = FactoryBot.create(
      :follow_relationship,
      user_id: @user1.id,
      following_user_id: @user2.id
    )
    @params = {
      user_id: @user2.id,
      is_opened: false,
      action_from: 'test',
      follow_relationship_id: @followRelationship.id,
      invitation_id: 0
    }
    expect { post '/v1/notification/', params: @params }.to change(Notification, :count).by(+1)
    @params = {
      user_id: @user2.id,
      action_from: 'test'
    }
    patch '/v1/notification/', params: @params
    @json = JSON.parse(response.body)
    # responseの可否判定
    expect(response.status).to eq(@status_code_ok)
  end
end
