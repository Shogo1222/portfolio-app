# frozen_string_literal: true

require 'rails_helper'

describe 'Favorite' do
  before(:each) do
    @user_id = 1
    @shop_id = 1
    @status_code_ok = 200
  end
  it 'お気に入りを表示' do
    user = FactoryBot.create(:user)
    FactoryBot.create(:favorite, user_id: user.id)
    params = { user_id: @user_id, shop_id: @shop_id }
    get '/v1/favorite', params: params
    @json = JSON.parse(response.body)
    expect(response.status).to eq(@status_code_ok)
  end

  it '新しくお気に入りする' do
    user = FactoryBot.create(:user)
    params = { user_id: user.id, shop_id: @shop_id }
    expect { post '/v1/favorite/', params: params }.to change(Favorite, :count).by(+1)
  end

  it 'お気に入りを追加して、削除する' do
    user = FactoryBot.create(:user)
    FactoryBot.create(:favorite, user_id: user.id)
    params = { user_id: user.id, shop_id: @shop_id }
    delete '/v1/favorite/', params: params
    @json = JSON.parse(response.body)
    expect(response.status).to eq(@status_code_ok)
    get '/v1/favorite/', params: params
    @json = JSON.parse(response.body)
    expect(response.status).to eq(@status_code_ok)
  end
end
