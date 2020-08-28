require 'rails_helper'

RSpec.describe ShopTag, type: :model do
  it '正常テスト' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @shopTag = ShopTag.new(
      logged_shop_id: @logged_shop.id,
      tag: 'test'
    )
    expect(@shopTag).to be_valid
  end

  it '異常テスト_nil_logged_shop_id' do
    @shopTag = ShopTag.new(
      logged_shop_id: nil,
      tag: 'test'
    )
    @shopTag.valid?
    expect(@shopTag.errors[:logged_shop_id]).to include("can't be blank")
  end

  it '異常テスト_nil_tag' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @shopTag = ShopTag.new(
      logged_shop_id: @logged_shop.id,
      tag: nil
    )
    @shopTag.valid?
    expect(@shopTag.errors[:tag]).to include("can't be blank")
  end
end
