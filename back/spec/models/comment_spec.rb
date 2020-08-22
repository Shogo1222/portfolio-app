require 'rails_helper'

RSpec.describe Comment, type: :model do
  it '正常テスト' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @comment = Comment.new(
      user_id: @user.id,
      user_name: @user.name,
      logged_shop_id: @logged_shop.id,
      shop_id: 'test',
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
      user_name: @user.name,
      logged_shop_id: @logged_shop.id,
      shop_id: 'test',
      comment: 'test',
      image: 'image'
    )
    @comment.valid?
    expect(@comment.errors[:user_id]).to include("can't be blank")
  end

  it '異常テスト_nil_user_name' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @comment = Comment.new(
      user_id: @user.id,
      user_name: nil,
      logged_shop_id: @logged_shop.id,
      shop_id: 'test',
      comment: 'test',
      image: 'image'
    )
    @comment.valid?
    expect(@comment.errors[:user_name]).to include("can't be blank")
  end

  it '異常テスト_nil_shop_id' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @comment = Comment.new(
      user_id: @user.id,
      user_name: @user.name,
      logged_shop_id: @logged_shop.id,
      shop_id: nil,
      comment: 'test',
      image: 'image'
    )
    @comment.valid?
    expect(@comment.errors[:shop_id]).to include("can't be blank")
  end

  it '異常テスト_nil_comment' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @comment = Comment.new(
      user_id: @user.id,
      user_name: @user.name,
      logged_shop_id: @logged_shop.id,
      shop_id: 'test',
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
      user_name: @user.name,
      logged_shop_id: @logged_shop.id,
      shop_id: 'test',
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
      user_name: @user.name,
      logged_shop_id: @logged_shop.id,
      shop_id: 'test',
      comment: '',
      image: 'image'
    )
    expect(@comment.invalid?).to be true
  end
end
