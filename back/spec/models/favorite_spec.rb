require 'rails_helper'

RSpec.describe Favorite, type: :model do
  it '正常テスト' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @favorite = Favorite.new(
      user_id: @user.id,
      logged_shop_id: @logged_shop.id
    )
    expect(@favorite).to be_valid
  end

  it '異常テスト_nil_user_id' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @favorite = Favorite.new(
      user_id: nil,
      logged_shop_id: @logged_shop.id
    )
    @favorite.valid?
    expect(@favorite.errors[:user_id]).to include("can't be blank")
  end

  it '異常テスト_nil_logged_shop_id' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @favorite = Favorite.new(
      user_id: @user.id,
      logged_shop_id: nil
    )
    @favorite.valid?
    expect(@favorite.errors[:logged_shop]).to include('must exist')
  end
end
