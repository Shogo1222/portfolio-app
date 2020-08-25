# frozen_string_literal: true

require 'rails_helper'

describe 'LoggedShop' do
  before(:each) do
    @status_code_ok = 200
  end
  it '記録されたショップを表示1' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @params = { user_id: @logged_shop.user_id, action_from: @logged_shop.action_from }
    get '/v1/logged_shop/', params: @params
    @json = JSON.parse(response.body)
    # responseの可否判定
    expect(response.status).to eq(@status_code_ok)
  end

  it '記録されたショップを表示2' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @params = { shop_id: @logged_shop.shop_id, action_from: @logged_shop.action_from }
    get '/v1/logged_shop/', params: @params
    @json = JSON.parse(response.body)
    # responseの可否判定
    expect(response.status).to eq(@status_code_ok)
  end

  it '記録されたショップを登録' do
    @user = FactoryBot.create(:user)
    @params = { user_id: @logged_shop.user_id, shop_id: @logged_shop.shop_id, action_from: @logged_shop.action_from }
    expect { post '/v1/logged_shop/', params: @params }.to change(LoggedShop, :count).by(+1)
  end

  it '記録されたショップを削除' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @params = { user_id: @logged_shop.user_id, shop_id: @logged_shop.shop_id, action_from: @logged_shop.action_from }
    expect { delete '/v1/logged_shop/', params: @params }.to change(LoggedShop, :count).by(-1)
  end
end
