# frozen_string_literal: true

class CommentFavorite < ApplicationRecord
  validates :user_id, :comment_id, presence: true

  belongs_to :user
  belongs_to :comment
end
