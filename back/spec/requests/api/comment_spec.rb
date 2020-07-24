# frozen_string_literal: true

require 'rails_helper'

describe 'Comment' do
  before(:each) do
    @user_id = 1
    @shop_id = 1
    @user_name = 'test'
    @comment = 'commentTest'
    @params = { user_id: @user_id, user_name: @user_name, shop_id: @shop_id, comment: @comment }
    @status_code_ok = 200
  end
  it 'コメントを表示' do
    FactoryBot.create(:user)
    FactoryBot.create(:comment)
    get '/v1/comment', params: @params
    @json = JSON.parse(response.body)
    expect(response.status).to eq(200)
  end

  it '新しくコメントをする' do
    FactoryBot.create(:user)
    expect { post '/v1/comment/', params: @params }.to change(Comment, :count).by(+1)
  end

end
