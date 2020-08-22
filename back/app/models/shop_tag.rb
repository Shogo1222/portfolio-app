# frozen_string_literal: true

class ShopTag < ApplicationRecord
  validates :logged_shop_id, :shop_id, :tag, presence: true

  belongs_to :logged_shop
end
