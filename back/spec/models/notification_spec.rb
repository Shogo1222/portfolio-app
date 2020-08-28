require 'rails_helper'

RSpec.describe Notification, type: :model do
  it '正常テスト1' do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @followRelationship = FactoryBot.create(
      :follow_relationship,
      user_id: @user1.id,
      following_user_id: @user2.id
    )
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user1.id)
    @invitation = FactoryBot.create(
      :invitation,
      user_id: @user1.id,
      to_user_id: @user2.id,
      logged_shop_id: @logged_shop.id
    )
    @notification = Notification.new(
      user_id: @user2.id,
      is_opened: false,
      action_from: 'test',
      follow_relationship_id: 0,
      invitation_id: @invitation.id
    )
    expect(@notification).to be_valid
  end

  it '正常テスト2' do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @followRelationship = FactoryBot.create(
      :follow_relationship,
      user_id: @user1.id,
      following_user_id: @user2.id
    )
    @notification = Notification.new(
      user_id: @user2.id,
      is_opened: false,
      action_from: 'test',
      follow_relationship_id: @followRelationship.id
    )

    expect(@notification).to be_valid
  end

  it '異常テスト_nil_user_id' do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @followRelationship = FactoryBot.create(
      :follow_relationship,
      user_id: @user1.id,
      following_user_id: @user2.id
    )
    @notification = Notification.new(
      user_id: nil,
      is_opened: false,
      action_from: 'test',
      follow_relationship_id: @followRelationship.id
    )

    @notification.valid?
    expect(@notification.errors[:user_id]).to include("can't be blank")
  end

  it '異常テスト_nil_action_from' do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @followRelationship = FactoryBot.create(
      :follow_relationship,
      user_id: @user1.id,
      following_user_id: @user2.id
    )
    @notification = Notification.new(
      user_id: @user2.id,
      is_opened: false,
      action_from: nil,
      follow_relationship_id: @followRelationship.id
    )

    @notification.valid?
    expect(@notification.errors[:action_from]).to include("can't be blank")
  end
end
