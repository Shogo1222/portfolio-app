# frozen_string_literal: true

class DisplayedShop < ApplicationRecord
  validates :user_id, :shop_id, :shop_json, presence: true

  belongs_to :user
end
