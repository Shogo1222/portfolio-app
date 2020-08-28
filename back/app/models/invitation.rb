class Invitation < ApplicationRecord
  validates :user_id, :to_user_id, presence: true

  belongs_to :user
  belongs_to :logged_shop
end
