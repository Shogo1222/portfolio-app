# frozen_string_literal: true

require 'rails_helper'

describe 'User' do
  before(:each) do
    @status_code_ok = 200
  end
  it 'ユーザーを表示1' do
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

  it 'ユーザーを表示2' do
    @user = FactoryBot.create(:user, email: 'test@gmail.com', name: 'test', uid: 'test', image: '')
    @params = { id: @user.id }
    get '/v1/users/', params: @params
    @json = JSON.parse(response.body)
    # responseの可否判定
    expect(response.status).to eq(@status_code_ok)
    # 入力したデータとの整合性判定
    expect(@json['email']).to eq('test@gmail.com')
    expect(@json['name']).to eq('test')
    expect(@json['uid']).to eq('test')
  end

  it 'ユーザーを表示3' do
    @user1 = FactoryBot.create(:user, email: 'test1@gmail.com', name: 'test1', uid: 'test1', image: '')
    @user2 = FactoryBot.create(:user, email: 'test2@gmail.com', name: 'test2', uid: 'test2', image: '')
    @params = { ids: [@user1.id, @user2.id] }
    get '/v1/users/', params: @params
    @json = JSON.parse(response.body)
    # responseの可否判定
    expect(response.status).to eq(@status_code_ok)
    # 入力したデータとの整合性判定
    expect(@json[0]['email']).to eq('test1@gmail.com')
    expect(@json[0]['name']).to eq('test1')
    expect(@json[0]['uid']).to eq('test1')
    expect(@json[1]['email']).to eq('test2@gmail.com')
    expect(@json[1]['name']).to eq('test2')
    expect(@json[1]['uid']).to eq('test2')
  end

  it 'ユーザーを表示4' do
    @user = FactoryBot.create(:user, email: 'test@gmail.com', name: 'test', uid: 'test', image: '')
    @params = { name: 'test' }
    get '/v1/users/', params: @params
    @json = JSON.parse(response.body)
    # responseの可否判定
    expect(response.status).to eq(@status_code_ok)
    # 入力したデータとの整合性判定
    expect(@json[0]['email']).to eq('test@gmail.com')
    expect(@json[0]['name']).to eq('test')
    expect(@json[0]['uid']).to eq('test')
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
