require 'rails_helper'

RSpec.describe LoggedShop, type: :model do
  it '正常テスト' do
    @user = FactoryBot.create(:user)
    @logged_shop = LoggedShop.new(
      user_id: @user.id,
      action_from: 'test',
      shop_id: 'test',
      lat: 'test',
      lng: 'test',
      name: 'test',
      catch: 'test',
      capacity: 'test',
      photo: 'test',
      budget: 'test',
      budget_memo: 'test',
      mobile_access: 'test',
      open: 'test',
      non_smoking: 'test',
      address: 'test'
    )
    expect(@logged_shop).to be_valid
  end

  it '異常テスト_nil_user_id' do
    @logged_shop = LoggedShop.new(
      user_id: nil,
      action_from: 'test',
      shop_id: 'test',
      lat: 'test',
      lng: 'test',
      name: 'test',
      catch: 'test',
      capacity: 'test',
      photo: 'test',
      budget: 'test',
      budget_memo: 'test',
      mobile_access: 'test',
      open: 'test',
      non_smoking: 'test',
      address: 'test'
    )
    @logged_shop.valid?
    expect(@logged_shop.errors[:user_id]).to include("can't be blank")
  end

  it '異常テスト_nil_shop_id' do
    @user = FactoryBot.create(:user)
    @logged_shop = LoggedShop.new(
      user_id: @user.id,
      shop_id: nil,
      action_from: 'test',
      lat: 'test',
      lng: 'test',
      name: 'test',
      catch: 'test',
      capacity: 'test',
      photo: 'test',
      budget: 'test',
      budget_memo: 'test',
      mobile_access: 'test',
      open: 'test',
      non_smoking: 'test',
      address: 'test'
    )
    @logged_shop.valid?
    expect(@logged_shop.errors[:shop_id]).to include("can't be blank")
  end

  it '異常テスト_nil_action_from' do
    @user = FactoryBot.create(:user)
    @logged_shop = LoggedShop.new(
      user_id: @user.id,
      action_from: nil,
      shop_id: 'test',
      lat: 'test',
      lng: 'test',
      name: 'test',
      catch: 'test',
      capacity: 'test',
      photo: 'test',
      budget: 'test',
      budget_memo: 'test',
      mobile_access: 'test',
      open: 'test',
      non_smoking: 'test',
      address: 'test'
    )
    @logged_shop.valid?
    expect(@logged_shop.errors[:action_from]).to include("can't be blank")
  end
end
