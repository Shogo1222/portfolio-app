# frozen_string_literal: true

require 'rails_helper'

describe 'Favorite' do
  before(:each) do
    @user_id = 1
    @shop_id = 1
    @status_code_ok = 200
  end
  it 'お気に入りを表示' do
    @user = FactoryBot.create(:user)
    FactoryBot.create(:favorite, user_id: @user.id, shop_id: 'test')
    @params = { user_id: @user.id, shop_id: 'test' }
    get '/v1/favorite', params: @params
    @json = JSON.parse(response.body)
    # responseの可否判定
    expect(response.status).to eq(@status_code_ok)
    # 入力したデータとの整合性判定
    expect(@json[0]['user_id']).to eq(@user.id)
    expect(@json[0]['shop_id']).to eq('test')
  end

  it '新しくお気に入りする' do
    @user = FactoryBot.create(:user)
    @params = { user_id: @user.id, shop_id: 'test' }
    expect { post '/v1/favorite/', params: @params }.to change(Favorite, :count).by(+1)
  end

  it 'お気に入りを削除する' do
    @user = FactoryBot.create(:user)
    FactoryBot.create(:favorite, user_id: @user.id, shop_id: 'test')
    @params = { user_id: @user.id, shop_id: 'test' }
    expect { delete '/v1/favorite/', params: @params }.to change(Favorite, :count).by(-1)
    @json = JSON.parse(response.body)
    expect(response.status).to eq(@status_code_ok)
  end
end
