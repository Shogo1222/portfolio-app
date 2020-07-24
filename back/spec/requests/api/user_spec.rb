# frozen_string_literal: true

require 'rails_helper'

describe 'User' do
  before(:each) do
    @email = 'test@gmail.com'
    @uid = 1
    @user_name = 'testUser'
    @comment = 'commentTest'
    @params = { email: @email, uid: @uid, name: @user_name }
    @status_code_ok = 200
  end
  it 'ユーザーを表示' do
    FactoryBot.create(:user)
    get '/v1/users/', params: @params
    @json = JSON.parse(response.body)
    expect(response.status).to eq(@status_code_ok)
  end

  it '新しくユーザー登録' do
    expect { post '/v1/users/', params: @params }.to change(User, :count).by(+1)
  end
end
