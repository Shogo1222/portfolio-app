class LoggedShop < ApplicationRecord
  validates :user_id, :shop_id, :action_from, presence: true
  validates :user_id, uniqueness: { scope: %i[shop_id action_from] }

  has_many :visited_shops, foreign_key: :user_id, dependent: :destroy
  has_many :comments, foreign_key: :user_id, dependent: :destroy
  has_many :favorites, foreign_key: :user_id, dependent: :destroy
  has_many :shop_tags, foreign_key: :user_id, dependent: :destroy

  belongs_to :user
end
