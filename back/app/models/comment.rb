class Comment < ApplicationRecord
  validates :user_id, :user_name, :shop_id, :comment, presence: true
  validates :comment, length: { minimum: 1, maximum: 100 }

  has_many :user
end
