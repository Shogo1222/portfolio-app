# frozen_string_literal: true

class Comment < ApplicationRecord
  validates :user_id, :user_name, :shop_id, :comment, presence: true
  validates :comment, length: { minimum: 1, maximum: 100 }

  belongs_to :user
  has_many :comment_favorites, dependent: :destroy

  mount_uploader :image, ImageUploader
end
