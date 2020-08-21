require 'rails_helper'

RSpec.describe User, type: :model do
  it '正常テスト' do
    @user = User.new(
      email: 'test@gmail.com',
      uid: 'test',
      name: 'test',
      image: 'test'
    )
    expect(@user).to be_valid
  end

  it '異常テスト_nil_email' do
    @user = User.new(
      email: nil,
      uid: 'test',
      name: 'test',
      image: 'test'
    )
    @user.valid?
    expect(@user.errors[:email]).to include("can't be blank")
  end

  it '異常テスト_nil_uid' do
    @user = User.new(
      email: 'test@gmail.com',
      uid: nil,
      name: 'test',
      image: 'test'
    )
    @user.valid?
    expect(@user.errors[:uid]).to include("can't be blank")
  end

  it '異常テスト_nil_name' do
    @user = User.new(
      email: 'test@gmail.com',
      uid: 'test',
      name: nil,
      image: 'test'
    )
    @user.valid?
    expect(@user.errors[:name]).to include("can't be blank")
  end

  it '異常テスト_over_30_email' do
    @user = User.new(
      email: 'a' * 31,
      uid: 'test',
      name: 'test',
      image: 'test'
    )
    expect(@user.invalid?).to be true
  end

  it '異常テスト_under_5_email' do
    @user = User.new(
      email: 'a' * 4,
      uid: 'test',
      name: 'test',
      image: 'test'
    )
    expect(@user.invalid?).to be true
  end

  it '異常テスト_over_8_name' do
    @user = User.new(
      email: 'test@gmail.com',
      uid: 'test',
      name: 'a' * 9,
      image: 'test'
    )
    expect(@user.invalid?).to be true
  end
end
