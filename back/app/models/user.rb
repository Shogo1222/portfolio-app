# frozen_string_literal: true

class User < ApplicationRecord
  validates :email, :uid, :name, presence: true
  validates :email, length: { minimum: 5, maximum: 30 }
  validates :name, length: { maximum: 8 }

  has_many :comments, foreign_key: :user_id, dependent: :destroy
  has_many :comment_favorites, foreign_key: :user_id, dependent: :destroy

  has_many :favorites, foreign_key: :user_id, dependent: :destroy

  has_many :messages, foreign_key: :user_id, dependent: :destroy
  has_many :messages, foreign_key: :to_user_id, dependent: :destroy

  has_many :follow_relationships, foreign_key: :user_id, dependent: :destroy
  has_many :follow_relationships, foreign_key: :following_user_id, dependent: :destroy

  has_many :user_tags, foreign_key: :user_id, dependent: :destroy

  has_many :logged_shops, foreign_key: :user_id, dependent: :destroy
  has_many :visited_shops, foreign_key: :user_id, dependent: :destroy

  mount_uploader :image, ImageUploader
end
