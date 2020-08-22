# frozen_string_literal: true

require 'rails_helper'

describe 'CommentFavorite' do
  before(:each) do
    @status_code_ok = 200
  end
  it 'コメントのお気に入りを表示' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @comment = FactoryBot.create(:comment, user_id: @user.id, logged_shop_id: @logged_shop.id, user_name: @user.name, shop_id: 'test', comment: 'test')
    FactoryBot.create(:comment_favorite, comment_id: @comment.id, user_id: @user.id, shop_id: 'test')
    @params = { comment_id: @comment.id }
    get '/v1/comment_favorite', params: @params
    @json = JSON.parse(response.body)
    # responseの可否判定
    expect(response.status).to eq(@status_code_ok)
    # 入力したデータとの整合性判定
    expect(@json[0]['user_id']).to eq(@user.id)
    expect(@json[0]['comment_id']).to eq(@comment.id)
    expect(@json[0]['shop_id']).to eq('test')
  end

  it '新しくコメントのお気に入りする' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @comment = FactoryBot.create(:comment, user_id: @user.id, logged_shop_id: @logged_shop.id, user_name: @user.name, shop_id: 'test', comment: 'test')
    @params = { user_id: @user.id, comment_id: @comment.id, shop_id: 'test' }
    expect { post '/v1/comment_favorite/', params: @params }.to change(CommentFavorite, :count).by(+1)
  end

  it 'コメントのお気に入りを削除する' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @comment = FactoryBot.create(:comment, user_id: @user.id, logged_shop_id: @logged_shop.id, user_name: @user.name, shop_id: 'test', comment: 'test')
    FactoryBot.create(:comment_favorite, comment_id: @comment.id, user_id: @user.id, shop_id: 'test')
    @params = { user_id: @user.id, comment_id: @comment.id }
    expect { delete '/v1/comment_favorite/', params: @params }.to change(CommentFavorite, :count).by(-1)
    @json = JSON.parse(response.body)
    expect(response.status).to eq(@status_code_ok)
  end
end
