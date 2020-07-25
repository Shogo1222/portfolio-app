class Favorite < ApplicationRecord
  validates :user_id, presence: true
  validates :shop_id, presence: true
  #validates :user_id, :shop_id, uniqueness: true

  has_many :user
end
