require 'rails_helper'

RSpec.describe Comment, type: :model do
  it '正常テスト' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @comment = Comment.new(
      user_id: @user.id,
      logged_shop_id: @logged_shop.id,
      comment: 'test',
      image: 'image'
    )
    expect(@comment).to be_valid
  end

  it '異常テスト_nil_user_id' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @comment = Comment.new(
      user_id: nil,
      logged_shop_id: @logged_shop.id,
      comment: 'test',
      image: 'image'
    )
    @comment.valid?
    expect(@comment.errors[:user_id]).to include("can't be blank")
  end

  it '異常テスト_nil_comment' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @comment = Comment.new(
      user_id: @user.id,
      logged_shop_id: @logged_shop.id,
      comment: nil,
      image: 'image'
    )
    @comment.valid?
    expect(@comment.errors[:comment]).to include("can't be blank")
  end

  it '異常テスト_over_100_comment' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @comment = Comment.new(
      user_id: @user.id,
      logged_shop_id: @logged_shop.id,
      comment: 'a' * 101,
      image: 'image'
    )
    expect(@comment.invalid?).to be true
  end

  it '異常テスト_under_1_comment' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @comment = Comment.new(
      user_id: @user.id,
      logged_shop_id: @logged_shop.id,
      comment: '',
      image: 'image'
    )
    expect(@comment.invalid?).to be true
  end
end
