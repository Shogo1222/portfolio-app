require 'rails_helper'

RSpec.describe ShopTag, type: :model do
  it '正常テスト' do
    @user = FactoryBot.create(:user)
    @shop = FactoryBot.create(:displayed_shop, user_id: @user.id)
    @shopTag = ShopTag.new(
      displayed_shop_id: @shop.id,
      shop_id: 'test',
      tag: 'test'
    )
    expect(@shopTag).to be_valid
  end

  it '異常テスト_nil_displayed_shop_id' do
    @shopTag = ShopTag.new(
      displayed_shop_id: nil,
      shop_id: 'test',
      tag: 'test'
    )
    @shopTag.valid?
    expect(@shopTag.errors[:displayed_shop_id]).to include("can't be blank")
  end

  it '異常テスト_nil_shop_id' do
    @user = FactoryBot.create(:user)
    @shop = FactoryBot.create(:displayed_shop, user_id: @user.id)
    @shopTag = ShopTag.new(
      displayed_shop_id: @shop.id,
      shop_id: nil,
      tag: 'test'
    )
    @shopTag.valid?
    expect(@shopTag.errors[:shop_id]).to include("can't be blank")
  end

  it '異常テスト_nil_tag' do
    @user = FactoryBot.create(:user)
    @shop = FactoryBot.create(:displayed_shop, user_id: @user.id)
    @shopTag = ShopTag.new(
      displayed_shop_id: @shop.id,
      shop_id: 'test',
      tag: nil
    )
    @shopTag.valid?
    expect(@shopTag.errors[:tag]).to include("can't be blank")
  end
end
