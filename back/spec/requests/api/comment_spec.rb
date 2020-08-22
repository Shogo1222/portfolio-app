# frozen_string_literal: true

require 'rails_helper'

describe 'Comment' do
  before(:each) do
    @status_code_ok = 200
  end
  it 'コメントを表示' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @comment = FactoryBot.create(:comment, user_id: @user.id, logged_shop_id: @logged_shop.id, user_name: @user.name, shop_id: 'test', comment: 'test')
    @params = { shop_id: @shop_id }
    get '/v1/comment', params: @params
    @json = JSON.parse(response.body)
    # responseの可否判定
    expect(response.status).to eq(@status_code_ok)
    # 入力したデータとの整合性判定
    expect(@json[0]['user_id']).to eq(@user.id)
    expect(@json[0]['user_name']).to eq(@user.name)
    expect(@json[0]['shop_id']).to eq('test')
    expect(@json[0]['comment']).to eq('test')
  end

  it '新しくコメントをする' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @params = { user_id: @user.id, logged_shop_id: @logged_shop.id, user_name: @user.name, shop_id: 'test', comment: 'test' }
    expect { post '/v1/comment/', params: @params }.to change(Comment, :count).by(+1)
  end

  it 'コメントを削除' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @comment = FactoryBot.create(:comment, user_id: @user.id, logged_shop_id: @logged_shop.id, user_name: @user.name, shop_id: 'test', comment: 'test')
    @params = { id: @comment.id, user_id: @user.id, shop_id: 'test' }
    expect { delete '/v1/comment/', params: @params }.to change(Comment, :count).by(-1)
    expect(response.status).to eq(@status_code_ok)
  end
end
