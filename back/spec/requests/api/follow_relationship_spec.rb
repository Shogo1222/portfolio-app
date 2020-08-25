# frozen_string_literal: true

require 'rails_helper'

describe 'FollowRelationship' do
  before(:each) do
    @status_code_ok = 200
  end
  it 'フォローを表示1' do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @follow_relationship = FactoryBot.create(:follow_relationship, user_id: @user1.id, following_user_id: @user2.id)
    @params = { user_id: @user1.id, following_user_id: @user2.id }
    get '/v1/follow_relationship', params: @params
    @json = JSON.parse(response.body)
    # responseの可否判定
    expect(response.status).to eq(@status_code_ok)
    # 入力したデータとの整合性判定
    expect(@json['user_id']).to eq(@user1.id)
    expect(@json['following_user_id']).to eq(@user2.id)
  end

  it 'フォローを表示2' do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @follow_relationship = FactoryBot.create(:follow_relationship, user_id: @user1.id, following_user_id: @user2.id)
    @params = { user_id: @user1.id }
    get '/v1/follow_relationship', params: @params
    @json = JSON.parse(response.body)
    # responseの可否判定
    expect(response.status).to eq(@status_code_ok)
    # 入力したデータとの整合性判定
    expect(@json[0]['user_id']).to eq(@user1.id)
    expect(@json[0]['following_user_id']).to eq(@user2.id)
  end

  it 'フォローを表示3' do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @follow_relationship = FactoryBot.create(:follow_relationship, user_id: @user1.id, following_user_id: @user2.id)
    @params = { following_user_id: @user2.id }
    get '/v1/follow_relationship', params: @params
    @json = JSON.parse(response.body)
    # responseの可否判定
    expect(response.status).to eq(@status_code_ok)
    # 入力したデータとの整合性判定
    expect(@json[0]['user_id']).to eq(@user1.id)
    expect(@json[0]['following_user_id']).to eq(@user2.id)
  end

  it 'フォローを追加' do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @params = { user_id: @user1.id, following_user_id: @user2.id }
    expect { post '/v1/follow_relationship/', params: @params }.to change(FollowRelationship, :count).by(+1)
  end

  it '相互フォローを追加' do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @params = { user_id: @user1.id, following_user_id: @user2.id }
    expect { post '/v1/follow_relationship/', params: @params }.to change(FollowRelationship, :count).by(+1)
    @params = { user_id: @user2.id, following_user_id: @user1.id }
    expect { post '/v1/follow_relationship/', params: @params }.to change(FollowRelationship, :count).by(+1)

    @params = { user_id: @user1.id, following_user_id: @user2.id }
    get '/v1/follow_relationship', params: @params
    @json = JSON.parse(response.body)
    # responseの可否判定
    expect(response.status).to eq(@status_code_ok)
    # 入力したデータとの整合性判定
    expect(@json['user_id']).to eq(@user1.id)
    expect(@json['following_user_id']).to eq(@user2.id)
    expect(@json['is_mutual_follow']).to eq(true)

    @params = { user_id: @user2.id, following_user_id: @user1.id }
    get '/v1/follow_relationship', params: @params
    @json = JSON.parse(response.body)
    # responseの可否判定
    expect(response.status).to eq(@status_code_ok)
    # 入力したデータとの整合性判定
    expect(@json['user_id']).to eq(@user2.id)
    expect(@json['following_user_id']).to eq(@user1.id)
    expect(@json['is_mutual_follow']).to eq(true)
  end

  it 'フォローを削除' do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @follow_relationship = FactoryBot.create(:follow_relationship, user_id: @user1.id, following_user_id: @user2.id)
    @params = { user_id: @user1.id, following_user_id: @user2.id }
    expect { delete '/v1/follow_relationship/', params: @params }.to change(FollowRelationship, :count).by(-1)
    @json = JSON.parse(response.body)
    expect(response.status).to eq(@status_code_ok)
  end
end
