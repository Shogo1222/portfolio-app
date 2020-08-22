# frozen_string_literal: true

require 'rails_helper'

describe 'VisitedShop' do
  before(:each) do
    @user_id = 1
    @shop_id = 1
    @status_code_ok = 200
  end
  it '訪問したショップを表示' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    FactoryBot.create(:visited_shop, user_id: @user.id, logged_shop_id: @logged_shop.id, shop_id: 'test')
    @params = { user_id: @user.id, shop_id: 'test' }
    get '/v1/visited_shop', params: @params
    @json = JSON.parse(response.body)
    # responseの可否判定
    expect(response.status).to eq(@status_code_ok)
    # 入力したデータとの整合性判定
    expect(@json[0]['user_id']).to eq(@user.id)
    expect(@json[0]['shop_id']).to eq('test')
  end

  it '新しく訪問したショップを登録する' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @params = { user_id: @user.id, logged_shop_id: @logged_shop.id, shop_id: 'test' }
    expect { post '/v1/visited_shop/', params: @params }.to change(VisitedShop, :count).by(+1)
  end

  it '訪問したショップを削除する' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    FactoryBot.create(:visited_shop, user_id: @user.id, logged_shop_id: @logged_shop.id, shop_id: 'test')
    @params = { user_id: @user.id, logged_shop_id: @logged_shop.id, shop_id: 'test' }
    expect { delete '/v1/visited_shop/', params: @params }.to change(VisitedShop, :count).by(-1)
    @json = JSON.parse(response.body)
    expect(response.status).to eq(@status_code_ok)
  end
end
