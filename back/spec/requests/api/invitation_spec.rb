# frozen_string_literal: true

require 'rails_helper'

describe 'Invitation' do
  before(:each) do
    @status_code_ok = 200
  end
  it '招待状を表示' do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user1.id)
    @invitation = FactoryBot.create(
      :invitation,
      user_id: @user1.id,
      to_user_id: @user2.id,
      logged_shop_id: @logged_shop.id
    )
    @params = { user_id: @user2.id }
    get '/v1/invitation', params: @params
    @json = JSON.parse(response.body)
    # responseの可否判定
    expect(response.status).to eq(@status_code_ok)
    # 入力したデータとの整合性判定
    expect(@json[0]['id']).to eq(@user1.id)
    expect(@json[0]['name']).to eq(@user1.name)
    expect(@json[0]['to_user_id']).to eq(@user2.id)
    expect(@json[0]['invitation_id']).to eq(@invitation.id)
    expect(@json[0]['shop_name']).to eq(@logged_shop.name)
    expect(@json[0]['catch_copy']).to eq(@logged_shop.catch)
    expect(@json[0]['lat']).to eq(@logged_shop.lat)
    expect(@json[0]['lng']).to eq(@logged_shop.lng)
    expect(@json[0]['capacity']).to eq(@logged_shop.capacity)
    expect(@json[0]['photo']).to eq(@logged_shop.photo)
    expect(@json[0]['budget']).to eq(@logged_shop.budget)
    expect(@json[0]['budget_memo']).to eq(@logged_shop.budget_memo)
    expect(@json[0]['mobile_access']).to eq(@logged_shop.mobile_access)
    expect(@json[0]['open_hour']).to eq(@logged_shop.open)
    expect(@json[0]['non_smoking']).to eq(@logged_shop.non_smoking)
    expect(@json[0]['address']).to eq(@logged_shop.address)
  end

  it '招待状を追加' do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user1.id)
    @params = {
      user_id: @user1.id,
      to_user_id: @user2.id,
      logged_shop_id: @logged_shop.id
    }
    expect { post '/v1/invitation/', params: @params }.to change(Invitation, :count).by(+1)
  end
end
