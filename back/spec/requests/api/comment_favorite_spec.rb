# frozen_string_literal: true

require 'rails_helper'

describe 'Favorite' do
  before(:each) do
    @user_id = 1
    @shop_id = 1
    @comment_id = 1
    @status_code_ok = 200
  end
  it 'コメントのお気に入りを表示' do
    user = FactoryBot.create(:user)
    comment = FactoryBot.create(:comment, user_id: user.id)
    FactoryBot.create(:comment_favorite, comment_id: comment.id, user_id: user.id)
    params = { comment_id: @comment_id }
    get '/v1/comment_favorite', params: params
    @json = JSON.parse(response.body)
    expect(response.status).to eq(@status_code_ok)
  end

  it '新しくコメントのお気に入りする' do
    user = FactoryBot.create(:user)
    comment = FactoryBot.create(:comment, user_id: user.id)
    params = { user_id: user.id, comment_id: comment.id, shop_id: @shop_id }
    expect { post '/v1/comment_favorite/', params: params }.to change(CommentFavorite, :count).by(+1)
  end

  it 'コメントのお気に入りを追加して、削除する' do
    user = FactoryBot.create(:user)
    comment = FactoryBot.create(:comment, user_id: user.id)
    FactoryBot.create(:comment_favorite, comment_id: comment.id, user_id: user.id)
    params = { user_id: user.id, comment_id: comment.id }
    delete '/v1/comment_favorite/', params: params
    @json = JSON.parse(response.body)
    expect(response.status).to eq(@status_code_ok)
    get '/v1/comment_favorite/', params: params
    @json = JSON.parse(response.body)
    expect(response.status).to eq(@status_code_ok)
  end
end
