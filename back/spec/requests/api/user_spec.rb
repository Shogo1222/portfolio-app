# frozen_string_literal: true

require 'rails_helper'

describe 'User' do
  before(:each) do
    @status_code_ok = 200
  end
  it 'ユーザーを表示' do
    FactoryBot.create(:user, email: 'test@gmail.com', name: 'test', uid: 'test', image: '')
    @params = { uid: 'test' }
    get '/v1/users/', params: @params
    @json = JSON.parse(response.body)
    # responseの可否判定
    expect(response.status).to eq(@status_code_ok)
    # 入力したデータとの整合性判定
    expect(@json['email']).to eq('test@gmail.com')
    expect(@json['name']).to eq('test')
    expect(@json['uid']).to eq('test')
  end

  it '新しくユーザー登録' do
    @params = { email: 'test@gmail.com', name: 'test', uid: 'test', image: '' }
    expect { post '/v1/users/', params: @params }.to change(User, :count).by(+1)
  end

  it 'ユーザー削除' do
    FactoryBot.create(:user, email: 'test@gmail.com', name: 'test', uid: 'test', image: '')
    @params = { uid: 'test' }
    expect { delete '/v1/users/', params: @params }.to change(User, :count).by(-1)
  end
end
