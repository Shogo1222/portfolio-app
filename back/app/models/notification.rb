class Notification < ApplicationRecord
  validates :user_id, :action_from, presence: true
end
