require 'rails_helper'

RSpec.describe UserTag, type: :model do
  it '正常テスト' do
    @user = FactoryBot.create(:user)
    @userTag = UserTag.new(
      user_id: @user.id,
      tag: 'test'
    )
    expect(@userTag).to be_valid
  end

  it '異常テスト_nil_user_id' do
    @userTag = UserTag.new(
      user_id: nil,
      tag: 'test'
    )
    @userTag.valid?
    expect(@userTag.errors[:user_id]).to include("can't be blank")
  end

  it '異常テスト_nil_tag' do
    @user = FactoryBot.create(:user)
    @userTag = UserTag.new(
      user_id: @user.id,
      tag: nil
    )
    @userTag.valid?
    expect(@userTag.errors[:tag]).to include("can't be blank")
  end
end
