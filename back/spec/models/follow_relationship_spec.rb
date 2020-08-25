require 'rails_helper'

RSpec.describe FollowRelationship, type: :model do
  it '正常テスト' do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @followRelationship = FollowRelationship.new(
      user_id: @user1.id,
      following_user_id: @user2.id,
      is_mutual_follow: true
    )
    expect(@followRelationship).to be_valid
  end

  it '異常テスト_nil_user_id' do
    @user2 = FactoryBot.create(:user)
    @followRelationship = FollowRelationship.new(
      user_id: nil,
      following_user_id: @user2.id,
      is_mutual_follow: true
    )
    @followRelationship.valid?
    expect(@followRelationship.errors[:user_id]).to include("can't be blank")
  end

  it '異常テスト_nil_following_user_id' do
    @user1 = FactoryBot.create(:user)
    @followRelationship = FollowRelationship.new(
      user_id: @user1.id,
      following_user_id: nil,
      is_mutual_follow: true
    )
    @followRelationship.valid?
    expect(@followRelationship.errors[:following_user_id]).to include("can't be blank")
  end
end
