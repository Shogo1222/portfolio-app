require 'rails_helper'

RSpec.describe CommentFavorite, type: :model do
  it '正常テスト' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @comment = FactoryBot.create(:comment, user_id: @user.id, logged_shop_id: @logged_shop.id, comment: 'test')
    @comment_favorite = CommentFavorite.new(
      user_id: @user.id,
      comment_id: @comment.id
    )
    expect(@comment_favorite).to be_valid
  end

  it '異常テスト_nil_user_id' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @comment = FactoryBot.create(:comment, user_id: @user.id, logged_shop_id: @logged_shop.id, comment: 'test')
    @comment_favorite = CommentFavorite.new(
      user_id: nil,
      comment_id: @comment.id
    )
    @comment_favorite.valid?
    expect(@comment_favorite.errors[:user_id]).to include("can't be blank")
  end

  it '異常テスト_nil_comment_id' do
    @user = FactoryBot.create(:user)
    @logged_shop = FactoryBot.create(:logged_shop, user_id: @user.id)
    @comment = FactoryBot.create(:comment, user_id: @user.id, logged_shop_id: @logged_shop.id, comment: 'test')
    @comment_favorite = CommentFavorite.new(
      user_id: @user.id,
      comment_id: nil
    )
    @comment_favorite.valid?
    expect(@comment_favorite.errors[:comment_id]).to include("can't be blank")
  end
end
