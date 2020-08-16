# frozen_string_literal: true

class CommentFavorite < ApplicationRecord
  validates :user_id, :comment_id, :shop_id, presence: true

  has_many :user
  has_many :comment
end
