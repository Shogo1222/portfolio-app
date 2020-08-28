require 'rails_helper'

RSpec.describe Invitation, type: :model do
  it '正常テスト' do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @followRelationship = FactoryBot.create(
      :follow_relationship,
      user_id: @user1.id,
      following_user_id: @user2.id
    )
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user1.id)
    @invitation = Invitation.new(
      user_id: @user1.id,
      to_user_id: @user2.id,
      logged_shop_id: @logged_shop.id
    )

    expect(@invitation).to be_valid
  end

  it '異常テスト_nil_user_id' do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @followRelationship = FactoryBot.create(
      :follow_relationship,
      user_id: @user1.id,
      following_user_id: @user2.id
    )
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user1.id)
    @invitation = Invitation.new(
      user_id: nil,
      to_user_id: @user2.id,
      logged_shop_id: @logged_shop.id
    )

    @invitation.valid?
    expect(@invitation.errors[:user_id]).to include("can't be blank")
  end

  it '異常テスト_nil_to_user_id' do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @followRelationship = FactoryBot.create(
      :follow_relationship,
      user_id: @user1.id,
      following_user_id: @user2.id
    )
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user1.id)
    @invitation = Invitation.new(
      user_id: @user1.id,
      to_user_id: nil,
      logged_shop_id: @logged_shop.id
    )

    @invitation.valid?
    expect(@invitation.errors[:to_user_id]).to include("can't be blank")
  end
end
