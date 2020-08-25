# frozen_string_literal: true

require 'rails_helper'

describe 'UserTag' do
  before(:each) do
    @status_code_ok = 200
  end

  it 'ユーザータグを表示・重複データを取得しない1' do
    @user = FactoryBot.create(:user)
    @userTag1 = FactoryBot.create(:user_tag, user_id: @user.id)
    @userTag2 = FactoryBot.create(:user_tag, user_id: @user.id)
    @params = { user_id: @user.id }
    get '/v1/user_tags/', params: @params
    @json = JSON.parse(response.body)
    # responseの可否判定
    expect(response.status).to eq(@status_code_ok)
    # 入力したデータとの整合性判定
    expect(@json.length).to eq(1)
    # タグが一件だけ取得できていることを判定
    expect(@json[0]['user_id']).to eq(@user.id)
  end

  it 'ユーザータグを表示・重複データを取得しない2' do
    @user = FactoryBot.create(:user)
    @userTag1 = FactoryBot.create(:user_tag, user_id: @user.id, tag: 'test')
    @userTag2 = FactoryBot.create(:user_tag, user_id: @user.id, tag: 'test')
    @params = { tag: 'test' }
    get '/v1/user_tags/', params: @params
    @json = JSON.parse(response.body)
    # responseの可否判定
    expect(response.status).to eq(@status_code_ok)
    # 入力したデータとの整合性判定
    expect(@json.length).to eq(1)
    # タグが一件だけ取得できていることを判定
    expect(@json[0]['user_id']).to eq(@user.id)
  end

  it '別のユーザーのタグを表示・重複データを取得しない' do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @userTag1 = FactoryBot.create(:user_tag, user_id: @user2.id)
    @userTag1 = FactoryBot.create(:user_tag, user_id: @user2.id)
    @params = { user_id: @user1.id }
    get '/v1/user_tags/recent_tag', params: @params
    @json = JSON.parse(response.body)
    # responseの可否判定
    expect(response.status).to eq(@status_code_ok)
    # 入力したデータとの整合性判定
    expect(@json.length).to eq(1)
    # タグが一件だけ取得できていることを判定
    expect(@json[0]['user_id']).to eq(@user2.id)
  end

  it '別のユーザーのタグを検索・重複データを取得しない' do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @userTag1 = FactoryBot.create(:user_tag, user_id: @user2.id, tag: 'test')
    @userTag1 = FactoryBot.create(:user_tag, user_id: @user2.id, tag: 'test')
    # あいまい条件
    @params = { user_id: @user1.id, tag: 'tes' }
    get '/v1/user_tags/recent_tag', params: @params
    @json = JSON.parse(response.body)
    # responseの可否判定
    expect(response.status).to eq(@status_code_ok)
    # タグが一件だけ取得できていることを判定
    expect(@json.length).to eq(1)
  end

  it '新しくユーザータグを登録' do
    @user = FactoryBot.create(:user)
    @params = { user_id: @user.id, tag: 'test' }
    expect { post '/v1/user_tags/', params: @params }.to change(UserTag, :count).by(+1)
  end

  it 'ユーザータグを削除' do
    @user = FactoryBot.create(:user)
    @userTag = FactoryBot.create(:user_tag, user_id: @user.id, tag: 'test')
    @params = { user_id: @user.id, tag: 'test' }
    expect { delete '/v1/user_tags/', params: @params }.to change(UserTag, :count).by(-1)
  end
end
