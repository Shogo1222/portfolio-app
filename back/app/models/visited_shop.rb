class VisitedShop < ApplicationRecord
  validates :user_id, :logged_shop_id, presence: true

  belongs_to :user
  belongs_to :logged_shop
end
