# frozen_string_literal: true

require 'rails_helper'

describe 'Comment' do
  before(:each) do
    @user_id = 1
    @shop_id = 1
    @comment = 'commentTest'
    @status_code_ok = 200
  end
  it 'コメントを表示' do
    user = FactoryBot.create(:user)
    Rails.logger.debug("デバッグ")
    Rails.logger.debug(user.name)
    Rails.logger.debug("デバッグ")

    params = { user_id: user.id, user_name: user.name, shop_id: @shop_id, comment: @comment }
    post '/v1/comment/', params: params
    get '/v1/comment', params: params
    @json = JSON.parse(response.body)
    expect(response.status).to eq(200)
  end

  it '新しくコメントをする' do
    user = FactoryBot.create(:user)
    params = { user_id: user.id, user_name: user.name, shop_id: @shop_id, comment: @comment }
    expect { post '/v1/comment/', params: params }.to change(Comment, :count).by(+1)
  end

  it 'コメントを削除' do
    user = FactoryBot.create(:user)
    params = { user_id: user.id, user_name: user.name, shop_id: @shop_id, comment: @comment }
    expect { post '/v1/comment/', params: params }.to change(Comment, :count).by(+1)
    delete '/v1/comment/', params: params
    @json = JSON.parse(response.body)
    expect(response.status).to eq(@status_code_ok)
  end

end
