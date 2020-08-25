# frozen_string_literal: true

require 'rails_helper'

describe 'ShopTag' do
  before(:each) do
    @status_code_ok = 200
  end

  it 'ショップタグを表示・重複データを取得しない1' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @shopTag1 = FactoryBot.create(:shop_tag, shop_id: @logged_shop.shop_id, tag: 'test', logged_shop_id: @logged_shop.id)
    @shopTag2 = FactoryBot.create(:shop_tag, shop_id: @logged_shop.shop_id, tag: 'test', logged_shop_id: @logged_shop.id)
    @params = { shop_id: @logged_shop.shop_id }
    get '/v1/shop_tags/', params: @params
    @json = JSON.parse(response.body)
    # responseの可否判定
    expect(response.status).to eq(@status_code_ok)
    # 入力したデータとの整合性判定
    expect(@json.length).to eq(1)
    # タグが一件だけ取得できていることを判定
    expect(@json[0]['shop_id']).to eq(@logged_shop.shop_id)
  end

  it 'ショップタグを表示・重複データを取得しない2' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @shopTag1 = FactoryBot.create(:shop_tag, shop_id: @logged_shop.shop_id, tag: 'test', logged_shop_id: @logged_shop.id)
    @shopTag2 = FactoryBot.create(:shop_tag, shop_id: @logged_shop.shop_id, tag: 'test', logged_shop_id: @logged_shop.id)
    @params = { tag: 'test' }
    get '/v1/shop_tags/', params: @params
    @json = JSON.parse(response.body)
    # responseの可否判定
    expect(response.status).to eq(@status_code_ok)
    # タグが一件だけ取得できていることを判定
    expect(@json.length).to eq(1)
    # 入力したデータとの整合性判定
    expect(@json[0]['shop_id']).to eq(@logged_shop.shop_id)
  end

  it '別のユーザーのタグを検索・重複データを取得しない' do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @logged_shop1 = FactoryBot.create(:logged_shop, user_id: @user1.id, shop_id: 'test1')
    @logged_shop2 = FactoryBot.create(:logged_shop, user_id: @user2.id, shop_id: 'test2')
    @shopTag1 = FactoryBot.create(:shop_tag, shop_id: @logged_shop1.shop_id, tag: 'test', logged_shop_id: @logged_shop1.id)
    @shopTag2 = FactoryBot.create(:shop_tag, shop_id: @logged_shop2.shop_id, tag: 'test', logged_shop_id: @logged_shop2.id)
    # あいまい条件
    @params = { shop_id: @logged_shop1.shop_id, tag: 'tes' }
    get '/v1/shop_tags/recent_tag', params: @params
    @json = JSON.parse(response.body)
    # responseの可否判定
    expect(response.status).to eq(@status_code_ok)
    # タグが一件だけ取得できていることを判定
    expect(@json.length).to eq(1)
    expect(@json[0]['tag']).to eq('test')
  end

  it '新しくショップタグを登録' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id, shop_id: 'test')
    @params = { shop_id: @logged_shop.shop_id, tag: 'test', logged_shop_id: @logged_shop.id }
    expect { post '/v1/shop_tags/', params: @params }.to change(ShopTag, :count).by(+1)
  end

  it 'ショップタグを削除' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id, shop_id: 'test')
    @shopTag = FactoryBot.create(:shop_tag, shop_id: @logged_shop.shop_id, tag: 'test', logged_shop_id: @logged_shop.id)
    @params = { shop_id: @logged_shop.shop_id, tag: 'test' }
    expect { delete '/v1/shop_tags/', params: @params }.to change(ShopTag, :count).by(-1)
  end
end
