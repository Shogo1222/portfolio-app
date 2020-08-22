require 'rails_helper'

RSpec.describe VisitedShop, type: :model do
  it '正常テスト' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @visited_shop = VisitedShop.new(
      user_id: @user.id,
      logged_shop_id: @logged_shop.id,
      shop_id: 'test'
    )
    expect(@visited_shop).to be_valid
  end

  it '異常テスト_nil_user_id' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @visited_shop = VisitedShop.new(
      user_id: nil,
      logged_shop_id: @logged_shop.id,
      shop_id: 'test'
    )
    @visited_shop.valid?
    expect(@visited_shop.errors[:user_id]).to include("can't be blank")
  end

  it '異常テスト_nil_logged_shop_id' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @visited_shop = VisitedShop.new(
      user_id: @user.id,
      logged_shop_id: nil,
      shop_id: 'test'
    )
    @visited_shop.valid?
    expect(@visited_shop.errors[:logged_shop_id]).to include("can't be blank")
  end

  it '異常テスト_nil_shop_id' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @visited_shop = VisitedShop.new(
      user_id: @user.id,
      logged_shop_id: @logged_shop.id,
      shop_id: nil
    )
    @visited_shop.valid?
    expect(@visited_shop.errors[:shop_id]).to include("can't be blank")
  end
end
