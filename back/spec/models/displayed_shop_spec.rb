require 'rails_helper'

RSpec.describe DisplayedShop, type: :model do
  it '正常テスト' do
    @user = FactoryBot.create(:user)
    @displayed_shop = DisplayedShop.new(
      user_id: @user.id,
      shop_id: 'test',
      shop_json: 'test'
    )
    expect(@displayed_shop).to be_valid
  end

  it '異常テスト_nil_user_id' do
    @displayed_shop = DisplayedShop.new(
      user_id: nil,
      shop_id: 'test',
      shop_json: 'test'
    )
    @displayed_shop.valid?
    expect(@displayed_shop.errors[:user_id]).to include("can't be blank")
  end

  it '異常テスト_nil_shop_id' do
    @user = FactoryBot.create(:user)
    @displayed_shop = DisplayedShop.new(
      user_id: @user.id,
      shop_id: nil,
      shop_json: 'test'
    )
    @displayed_shop.valid?
    expect(@displayed_shop.errors[:shop_id]).to include("can't be blank")
  end

  it '異常テスト_nil_shop_json' do
    @user = FactoryBot.create(:user)
    @displayed_shop = DisplayedShop.new(
      user_id: @user.id,
      shop_id: 'test',
      shop_json: nil
    )
    @displayed_shop.valid?
    expect(@displayed_shop.errors[:shop_json]).to include("can't be blank")
  end
end
