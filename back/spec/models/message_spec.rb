require 'rails_helper'

RSpec.describe Message, type: :model do
  it '正常テスト' do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @message = Message.new(
      user_id: @user1.id,
      to_user_id: @user2.id,
      title: 'test',
      body: 'test'
    )
    expect(@message).to be_valid
  end

  it '異常テスト_nil_user_id' do
    @user2 = FactoryBot.create(:user)
    @message = Message.new(
      user_id: nil,
      to_user_id: @user2.id,
      title: 'test',
      body: 'test'
    )
    @message.valid?
    expect(@message.errors[:user_id]).to include("can't be blank")
  end

  it '異常テスト_nil_to_user_id' do
    @user1 = FactoryBot.create(:user)
    @message = Message.new(
      user_id: @user1.id,
      to_user_id: nil,
      title: 'test',
      body: 'test'
    )
    @message.valid?
    expect(@message.errors[:to_user_id]).to include("can't be blank")
  end

  it '異常テスト_nil_title' do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @message = Message.new(
      user_id: @user1.id,
      to_user_id: @user2.id,
      title: nil,
      body: 'test'
    )
    @message.valid?
    expect(@message.errors[:title]).to include("can't be blank")
  end

  it '異常テスト_nil_body' do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @message = Message.new(
      user_id: @user1.id,
      to_user_id: @user2.id,
      title: 'test',
      body: nil
    )
    @message.valid?
    expect(@message.errors[:body]).to include("can't be blank")
  end
end
