# frozen_string_literal: true

class FollowRelationship < ApplicationRecord
  validates :user_id, :following_user_id, presence: true
  validates :user_id, uniqueness: { scope: :following_user_id }

  belongs_to :user
end
