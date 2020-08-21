# frozen_string_literal: true

class Favorite < ApplicationRecord
  validates :user_id, presence: true
  validates :shop_id, presence: true

  belongs_to :user
end
