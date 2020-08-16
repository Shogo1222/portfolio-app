class User < ApplicationRecord
  validates :email, :uid, :name, presence: true
  validates :email, length: { minimum: 5, maximum: 30 }
  validates :name, length: { maximum: 8 }

  has_many :comment, foreign_key: :user_id
  has_many :comment_favorite, foreign_key: :user_id
  has_many :favorite, foreign_key: :user_id
end
