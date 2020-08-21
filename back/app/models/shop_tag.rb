# frozen_string_literal: true

class ShopTag < ApplicationRecord
  validates :displayed_shop_id, :shop_id, :tag, presence: true

  belongs_to :displayed_shop
end
